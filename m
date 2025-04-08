Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F7206F18;
	Tue,  8 Apr 2025 12:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115523; cv=none; b=fv53K5OhFbeNC/a70BhfTa9fhsHxulDCAcEygf+JxEllm8bzjITdFMU2AGSsna5V5W+DL0WEOrDmTFE2EpZe1wtgMHS6CdoAseyyKeAYY1+kGqAefD2TLXySTdcYlkSLZgW36Uy/eqnCb/EXw0BE0DYGtX+twpfaQqslt23PtYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115523; c=relaxed/simple;
	bh=NhQmOC1qg30eleAs+FwP/Sm0cjyeZciDQKdfPB8RWIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFymc6qEA6n0343/6ten4O2eok18HkcFaHYFI7gqrIy9wPnoICCH4DlGMoh3bE9tRSCOmfAIjELu60kH39nCTHIuD+byHaGLuKHeOudWpJoqt/78pcObYNMyD1WqeSfmV6pGqgRsx7Bw4vR7iGQrz4FXvfdjm8deiWn97L5c1QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgUv4cqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgUv4cqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB3DC4CEE5;
	Tue,  8 Apr 2025 12:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115522;
	bh=NhQmOC1qg30eleAs+FwP/Sm0cjyeZciDQKdfPB8RWIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgUv4cqRAHMW8tZs6IM1GXarNzvaFNpJvfv7/oVm7jhFvIZwdDxqno6mxUK4Fp8TS
	 NB5Un4l8NiMh+Hg6G4Ajb0VCP8fDjCsOiFM+kRLaRqnIpulqf/LarkmofpVKnlaPJZ
	 bMUWDhrzjhKC4H+VfcA+vL72R4vHdIEH+10fYvbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 471/499] ksmbd: validate zero num_subauth before sub_auth is accessed
Date: Tue,  8 Apr 2025 12:51:23 +0200
Message-ID: <20250408104903.099239042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


