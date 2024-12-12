Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AFF6F2FE;
	Thu, 12 Dec 2024 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024936; cv=none; b=WJcea3o28eo9vO2s5juTogQryuCfMOVCWM+BBab5x1vYSMT0ZG0GWJfMJmfgziFD7Q0+GSAnP9gswrKUdwW/SMykRc7QrhjnLRoh4ZEzxQRF63PaBt8WFBwREzspST09gI3V2FIKEnEpqZ16Yu9vqJ+ZEbWPbM7mkM60Vq23uFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024936; c=relaxed/simple;
	bh=99GnEJNm+Gaged09gfJzZAjsUZfqpUcuzu16DR4uQtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0c3rrsDekKxcwFP68gpzd3dDOeuLMehmbjLKEiB4287UnPz2PuycVweIRXTFdA9ZGsnfpzwstJ0TUb0I17rd8m8M8L4gXFGhhdApjL+AktOtWt9h5iEex2F/8Vw+aYzSpzeqDFeWjDPpkjcxxaLLFMxT7U445QZBO6yMWxUX4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VawaJZsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VawaJZsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F13C4CECE;
	Thu, 12 Dec 2024 17:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024936;
	bh=99GnEJNm+Gaged09gfJzZAjsUZfqpUcuzu16DR4uQtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VawaJZsWez8XCTrogmJBYSRD5lt8zh55QyFROI1LMz0NiQG9HMC2n3dRpsTllNkUL
	 2+7iihkfK25G3hjyrFvLulLYESBTqtsyw595Xlh4CLl0FOAG/7lD2GF7hC6L1gkA+0
	 HOw/xxk+FzVOp3JUwz5cRRMwe4YZrJxVtYUgNeko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 446/459] jffs2: Prevent rtime decompress memory corruption
Date: Thu, 12 Dec 2024 16:03:04 +0100
Message-ID: <20241212144311.389003214@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kinsey Moore <kinsey.moore@oarcorp.com>

commit fe051552f5078fa02d593847529a3884305a6ffe upstream.

The rtime decompression routine does not fully check bounds during the
entirety of the decompression pass and can corrupt memory outside the
decompression buffer if the compressed data is corrupted. This adds the
required check to prevent this failure mode.

Cc: stable@vger.kernel.org
Signed-off-by: Kinsey Moore <kinsey.moore@oarcorp.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/compr_rtime.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/jffs2/compr_rtime.c
+++ b/fs/jffs2/compr_rtime.c
@@ -95,6 +95,9 @@ static int jffs2_rtime_decompress(unsign
 
 		positions[value]=outpos;
 		if (repeat) {
+			if ((outpos + repeat) >= destlen) {
+				return 1;
+			}
 			if (backoffs + repeat >= outpos) {
 				while(repeat) {
 					cpage_out[outpos++] = cpage_out[backoffs++];


