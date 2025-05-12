Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB487254863;
	Mon, 12 May 2025 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072645; cv=none; b=FKQhRR575ts87x9AvTXTiuPWAfeFHZtHVMJClXVi2Hmu3VjubOdaQLXgi4GADodN95CRFGc9m/KDHhODfUKi8oJtieSeO+7zGp5ZhZ1FPtR5ePFWW/0H3xIvd7NTzWYOmQ7JRECDWLy58aAac1rZP0ac6WMTpMOXkFhjJEgzC00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072645; c=relaxed/simple;
	bh=1pK4JFx3A9aS8ogsZ8COl7OGe4Xr1Xg/iE0MRsph1w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u60MO3+Q10dHKtpA4R5pKG3vb3jShprdzz45x1QnaQKXvx3sXDL81GunyeGJl50BmxdaSII28kSRVQmWqFmBU5eU17meMpbNBQaReUJ1yHDITvUuwWxS/rzTd8c4v1ST4A5yWf5UI2gjPb38TCxCg6strLsYARyh3vVX1I5FK78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMp5MUdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMp5MUdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4868DC4CEE7;
	Mon, 12 May 2025 17:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072645;
	bh=1pK4JFx3A9aS8ogsZ8COl7OGe4Xr1Xg/iE0MRsph1w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMp5MUdJQ0d5/otzgarDDi1HzMZLRtJ3kifMRNF22RdxscBTuIHfmHuk4yo00igxR
	 /RAHuNAx+HVrDdS8D+5FbjMoSCY7ZjIv2f1pw2ElLRMG/vh7shsgMGo5SvQc4K+N0O
	 TMxbPD1dUYH1tVovBBs1LFFva6OY6OcasgXANJIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 013/184] ksmbd: prevent rename with empty string
Date: Mon, 12 May 2025 19:43:34 +0200
Message-ID: <20250512172042.213988786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 53e3e5babc0963a92d856a5ec0ce92c59f54bc12 upstream.

Client can send empty newname string to ksmbd server.
It will cause a kernel oops from d_alloc.
This patch return the error when attempting to rename
a file or directory with an empty new name string.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -633,6 +633,11 @@ smb2_get_name(const char *src, const int
 		return name;
 	}
 
+	if (*name == '\0') {
+		kfree(name);
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (*name == '\\') {
 		pr_err("not allow directory name included leading slash\n");
 		kfree(name);


