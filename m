Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C941B663;
	Tue,  8 Apr 2025 12:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116027; cv=none; b=lWUT5YInwJUcGGNNWIM0Fft8Ukk74mzbIWnOyfKLxY51qYa5n1ZYIvZMpl6heZ7FliWu3DkoKmKJ+Ow3CcXWbuUb6Ln+Lt02urSCvngp+HU6NMVoGHBGhVa74nccLEDFSZbQ7Gn/9WXMGawQlH77WRRfKAVv0Dk71SXI5edWIyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116027; c=relaxed/simple;
	bh=yyVfyJtIPxFtBI0ciVo+jksmi0v2/Aj/go8FkmIAdXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxDc2+aWoA9+gb954HXSBQiN+vYH608qcN5j0M5KcWQAmlHx3reed2re2OvUn8szp+32ErirMT5KAZGdjiIKQkLfDj/Ju/YbsUu0KCZNUe8A4GJXXaoe8zixixFxabMWqV+c+c1FEILbnMPZYDY0dgY4nLDJH38p/EiPibCmWKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puCPNT4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puCPNT4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5B1C4CEE5;
	Tue,  8 Apr 2025 12:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116026;
	bh=yyVfyJtIPxFtBI0ciVo+jksmi0v2/Aj/go8FkmIAdXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puCPNT4HhANHwR7PvxaBEpHGaTewsHQOR+tPSgz56AR/7smhdYwOec+bKM5WJD/G2
	 0OP+S7zuj3myFFGaxhzVUtGUgbT7JJI2cObNq71P1iwBKX7IRJopZKrAOXPOETanPc
	 QvIlz4CdTn/woYyP7bkE1g6jKy2inwFdh2f04TWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 192/204] ksmbd: validate zero num_subauth before sub_auth is accessed
Date: Tue,  8 Apr 2025 12:52:02 +0200
Message-ID: <20250408104825.944268887@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit bf21e29d78cd2c2371023953d9c82dfef82ebb36 upstream.

Access psid->sub_auth[psid->num_subauth - 1] without checking
if num_subauth is non-zero leads to an out-of-bounds read.
This patch adds a validation step to ensure num_subauth != 0
before sub_auth is accessed.

Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -270,6 +270,11 @@ static int sid_to_id(struct user_namespa
 		return -EIO;
 	}
 
+	if (psid->num_subauth == 0) {
+		pr_err("%s: zero subauthorities!\n", __func__);
+		return -EIO;
+	}
+
 	if (sidtype == SIDOWNER) {
 		kuid_t uid;
 		uid_t id;


