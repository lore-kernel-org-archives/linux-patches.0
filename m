Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627F219922B;
	Thu,  6 Jun 2024 14:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683736; cv=none; b=J6ZKFGWEJ6gkfeisTVcYEWgz5ztJzNR5HmK1KsiO8CXKJD1zIa2pnROi3bctL58Qs0p937H9Ids3H1VKqU6jHJWgw703OZdlrMsN98qzD7a6dzG2OZn4Tp7I5eRPoIHeDfvvxPq0gVdUs3NnxrMpGO/YGMIEgWf63IuPu026DLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683736; c=relaxed/simple;
	bh=Nc7nvephQpWhW2EqwKOqD8ua3y1x1qm3kNjLBqCwZ5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQGakBDaJlhwn3Xx+j4jw3G5F2297vu3z/ZPe+yk+AHScTTVYEAws91qc6Rw7EURgExW9xG0xzKLyau6kDODiC8Y4etGo/ERLNvKW79SAPMCLB1dGYyLG9zfgeobuHVL6bNAdHvyRwhk86xk67YsuHubMsghP44T1j+/GZYpLIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MomJ6V1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MomJ6V1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46742C2BD10;
	Thu,  6 Jun 2024 14:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683736;
	bh=Nc7nvephQpWhW2EqwKOqD8ua3y1x1qm3kNjLBqCwZ5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MomJ6V1yBrHp8JP+WfZOcYE6AxwAqcpxnLVRNWLkKxhNGvoRmhP5ZcvwfHVd2p4a7
	 c0qvdI127PZ+lr47mXLGvC3AG4B5q7mqYJC8tYsrXOS7yxgUETLWFQ8QhMg4mXxG3z
	 stc9TljfKv1A8S0FIvuVnrSbYZJ8ZJ9ctJfvLD0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 656/744] i3c: add actual_len in i3c_priv_xfer
Date: Thu,  6 Jun 2024 16:05:28 +0200
Message-ID: <20240606131753.502316648@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit e5e3df06ac98d15cfb10bb5c12356709365e91b2 ]

In MIPI I3C Specification:

"Ninth Bit of SDR Target Returned (Read) Data as End-of-Data: In I2C, the
ninth Data bit from Target to Controller is an ACK by the Controller. By
contrast, in I3C this bit allows the Target to end a Read, and allows the
Controller to Abort a Read. In SDR terms, the ninth bit of Read data is
referred to as the T-Bit (for ‘Transition’)"

I3C allow devices early terminate data transfer. So need "actual_len" field
to indicate how much get by i3c_priv_xfer.

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231201222532.2431484-4-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 7f3d633b460b ("i3c: master: svc: change ENXIO to EAGAIN when IBI occurs during start frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/i3c/device.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/i3c/device.h b/include/linux/i3c/device.h
index 90fa83464f003..ef6217da8253b 100644
--- a/include/linux/i3c/device.h
+++ b/include/linux/i3c/device.h
@@ -54,6 +54,7 @@ enum i3c_hdr_mode {
  * struct i3c_priv_xfer - I3C SDR private transfer
  * @rnw: encodes the transfer direction. true for a read, false for a write
  * @len: transfer length in bytes of the transfer
+ * @actual_len: actual length in bytes are transferred by the controller
  * @data: input/output buffer
  * @data.in: input buffer. Must point to a DMA-able buffer
  * @data.out: output buffer. Must point to a DMA-able buffer
@@ -62,6 +63,7 @@ enum i3c_hdr_mode {
 struct i3c_priv_xfer {
 	u8 rnw;
 	u16 len;
+	u16 actual_len;
 	union {
 		void *in;
 		const void *out;
-- 
2.43.0



