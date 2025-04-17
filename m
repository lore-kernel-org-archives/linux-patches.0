Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B77C18C034;
	Thu, 17 Apr 2025 18:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913364; cv=none; b=HlslwVeBuBW2j9MH0UXJOm7ooSBKKEL4G8+Jdf24P672R0gIMe+F4X1/vpp7YBBUAX9DFzzEnAW0k2fRh1R4DD6PSdJfaVC57gNW85Wnz1Kb85m7VVzwUm2t7+BCWbylYolGXGjvh81+AyYKhC/+diL4E3rEw2Li85/rN5RE2l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913364; c=relaxed/simple;
	bh=GeUizqc88Yt5na6IKmRHw8eOqhLFXGMLV1m7EtBBpQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8K0WEdzoX4DUk3Btf6LUJZgNuOLa3Xs6bgmlfOVA8EiTMYIv25GPQi8hmYSXH8BdHPYgCj+OZhbqx2PHue9/+LkCov1TyHuWhtDZfBqgcZ1tAr3cEwzCHkp2UzgLijwSSrSEql72z/ZG8ZoAf/SDiZDYC9dscM+h8nDCan/470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVrQzi73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVrQzi73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19B7C4CEE4;
	Thu, 17 Apr 2025 18:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913364;
	bh=GeUizqc88Yt5na6IKmRHw8eOqhLFXGMLV1m7EtBBpQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVrQzi73vb9ZfddVebALTAW+P2BcQbBvewMdCDlj4FpTnWDRFDZPMD9Y+reSmtHOT
	 yFGQAKYxtQvuM1+EoagS0G//bJyLGJ2HRV1916Flu9Z+u21Tz95+JI9x71wmWuoeo5
	 ZlLZ6fMXsIeJsvZ1bEQ+ar5C9ahvonIZGJdtbKi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 314/449] smb311 client: fix missing tcon check when mounting with linux/posix extensions
Date: Thu, 17 Apr 2025 19:50:02 +0200
Message-ID: <20250417175130.752876068@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit b365b9d404b7376c60c91cd079218bfef11b7822 upstream.

When mounting the same share twice, once with the "linux" mount parameter
(or equivalently "posix") and then once without (or e.g. with "nolinux"),
we were incorrectly reusing the same tree connection for both mounts.
This meant that the first mount of the share on the client, would
cause subsequent mounts of that same share on the same client to
ignore that mount parm ("linux" vs. "nolinux") and incorrectly reuse
the same tcon.

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2455,6 +2455,8 @@ static int match_tcon(struct cifs_tcon *
 		return 0;
 	if (tcon->nodelete != ctx->nodelete)
 		return 0;
+	if (tcon->posix_extensions != ctx->linux_ext)
+		return 0;
 	return 1;
 }
 


