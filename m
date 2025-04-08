Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFD5268FD8;
	Tue,  8 Apr 2025 11:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112174; cv=none; b=V/kQpI/pIiSqnmo8Gskn3SpurvJBnbBq9VRxG4pXEuk1TzG6YJr1x+Ewtq0/1UePgvfKD1Sd0YMzIbTNcs+ihM+8xhe56nfGgkVDR1C7lI5WHuxWgfKfvWyvEftPtYcFf2d5GYV62sQZbsZdX1zR301KQMvaY8jdOU+wQvKUSOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112174; c=relaxed/simple;
	bh=+rbDFR+fIPx7Rdb4qN/Uia6+k4YuYg3seW/mKbGGP2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QStReOMm9Twk9nvwMhyFpvokpPXymqzg2AADlK9vyTbqhk9/plMIV19jAGd6xOgAV7zfXJYVGOq31kbmoX4VkCrL1qP5sumOLBit/nqE+BG0D0F5loR5Ik0ADyl6ew5Gixhf9wYEMGmAFbZYkhaoyQKtUTiVkLCZnqQu4E48S7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+cpH+/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+cpH+/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DA9C4CEE5;
	Tue,  8 Apr 2025 11:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112174;
	bh=+rbDFR+fIPx7Rdb4qN/Uia6+k4YuYg3seW/mKbGGP2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+cpH+/Bmjrh8XrDA008UFbGeFWq8ILrdUldX9E2EPcEyOyRfZhMsWgRI8TUXEquh
	 iRQGkSfVkURtnxnlrvTM7/AzAeBOUJgMTUx3uK5oWPZS6Q3CtMCzSEULMc1ciFg9o6
	 qKtPWK/z5EW35uVCdwBPLN0elj+4xLpm7HTYNJbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 703/731] ksmbd: validate zero num_subauth before sub_auth is accessed
Date: Tue,  8 Apr 2025 12:50:00 +0200
Message-ID: <20250408104930.619533926@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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
@@ -270,6 +270,11 @@ static int sid_to_id(struct mnt_idmap *i
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


