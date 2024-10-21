Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A9B1E47A6;
	Mon, 21 Oct 2024 10:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507523; cv=none; b=dR9ceP2vDU7SxIDcJmoIfEOXKto27IaKzJ/aCnHOd/IUI9tg30OAMAyjYIg4KdpgW1aUsuh7RIo2KDbnNmLI8mHy1jd8skQzqOVTg7Bu3E0TqKhtX35vAYsySqc+L5k75YnmEbOKlLUVhA/G7bE68LV+tsPHOIzjvKS40fNqK8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507523; c=relaxed/simple;
	bh=erN4E4uoHRlrXUEQvBFzMH1ovlpGMfwTmlopfY5WtX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avhl2HeRn/0WdZeyxlfMx7yuTCYVtRHnlxdAjYbY8fsVARxb89NEKJoYXyVdp82F6b5CUWhIKcXEUB6VsytJt08NHjWpAhzaKIqsq5AI6Ms2NHy6WorUgb7FwsqXwZk2u313/yqeLR4jy7Bn3DwmBDgoRs+Dg9FZAyQoDf5nKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Beu0A20Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Beu0A20Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D11AC4CEC7;
	Mon, 21 Oct 2024 10:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507522;
	bh=erN4E4uoHRlrXUEQvBFzMH1ovlpGMfwTmlopfY5WtX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Beu0A20QFAOCuNCtJJe0C5bz+pJZwZixlbU2K4wyQ9i9CviHVW9Qco7JALNU5jJ5/
	 32DpsANJq/O72qW0EkNhfg4wIdmxY0YN9lq0MhuNgaUtTueuoivvng4DlNifzzPCvT
	 G5AZpZ8j2wUP4PJuhdSoipzBctz9HGlg2nAJ4Tuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 06/82] udf: Provide function to mark entry as deleted using new directory iteration code
Date: Mon, 21 Oct 2024 12:24:47 +0200
Message-ID: <20241021102247.469656878@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 4cca7e3df7bea8661a0c2a70c0d250e9aa5cedb4 ]

Provide function udf_fiiter_delete_entry() to mark directory entry as
deleted using new directory iteration code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -714,6 +714,16 @@ out_ok:
 	return fi;
 }
 
+static void udf_fiiter_delete_entry(struct udf_fileident_iter *iter)
+{
+	iter->fi.fileCharacteristics |= FID_FILE_CHAR_DELETED;
+
+	if (UDF_QUERY_FLAG(iter->dir->i_sb, UDF_FLAG_STRICT))
+		memset(&iter->fi.icb, 0x00, sizeof(struct long_ad));
+
+	udf_fiiter_write_fi(iter, NULL);
+}
+
 static int udf_delete_entry(struct inode *inode, struct fileIdentDesc *fi,
 			    struct udf_fileident_bh *fibh,
 			    struct fileIdentDesc *cfi)


