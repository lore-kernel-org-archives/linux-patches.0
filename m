Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687783090F5;
	Mon, 13 Apr 2026 16:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097489; cv=none; b=mGocEcww2PbHHXYmSQSb5CGTBLAedBmMkZxfcoITLxEubhb+vlRhodjOlgVR/8w9ykCCgPHKIPfWlOZMSVHDrk2hkzk+qr/RCwBoYMHrvLn96CMpmamqKOUjLK1V+nYbyCrSRvtWzeTTu20MlwadPoEuSdJaXH0rrSo2hGrYya0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097489; c=relaxed/simple;
	bh=gk9W+ZT2Gd2KTiM1WASTjksdg36GqvKOxPBe13bb+mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lULg11zpr9g23VJ8CiVdMLqy5cXUu+G1wUVRq/0t5+OkyYqe1h2i25zSAK1q17fBU7hTEKTySXiFqO9WKB0+Vn2yGOr1hBcT84KbMn4N/M1hQtqtaOYuycG2FxbCoqfjsJdpQ9gpllWGiRPuvKQ3RcgeHsbbHn5hcMBbd6UV2Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKh0SiJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKh0SiJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25DEC2BCAF;
	Mon, 13 Apr 2026 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097489;
	bh=gk9W+ZT2Gd2KTiM1WASTjksdg36GqvKOxPBe13bb+mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKh0SiJmoUcDLUZS4zaGN2KyRRNOhQYiBcRXifiLX38Sr00400rr/4Kq+PebMftRs
	 ULjn1xYw1p/VA//WJ293T8m1CyS3PFI2UXMVSAr6HCtxp6UYhRLMmWWfm2K1B1XgCB
	 1MFHeNZp0LzwiTYToUkrLN9r3/Zzwc4LtaKrQmPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 5.15 155/570] libceph: admit message frames only in CEPH_CON_S_OPEN state
Date: Mon, 13 Apr 2026 17:54:46 +0200
Message-ID: <20260413155836.257435129@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ilya Dryomov <idryomov@gmail.com>

commit a5a373705081d7cc6363e16990e2361b0b362314 upstream.

Similar checks are performed for all control frames, but an early check
for message frames was missing.  process_message() is already set up to
terminate the loop in case the state changes while con->ops->dispatch()
handler is being executed.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2599,6 +2599,11 @@ static int __handle_control(struct ceph_
 	if (con->v2.in_desc.fd_tag != FRAME_TAG_MESSAGE)
 		return process_control(con, p, end);
 
+	if (con->state != CEPH_CON_S_OPEN) {
+		con->error_msg = "protocol error, unexpected message";
+		return -EINVAL;
+	}
+
 	ret = process_message_header(con, p, end);
 	if (ret < 0)
 		return ret;


