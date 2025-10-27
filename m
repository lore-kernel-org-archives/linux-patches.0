Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9142D218EB1;
	Mon, 27 Oct 2025 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590818; cv=none; b=b7i+p8gTn6MsCCbB8o8GIFOKrM/GoSfxGKHjl1CfUoPCOzSuWqlJgjIMOu46WP14CQaNBQAri9ekpur1l+I+Za19pnodE8sARs6rODXcaQl9Nzc70J8d2w1nLAI/1JPcBVRRLBnxHJpOAW9Px31LbkVE2ZTSgOd9LnN1Q0al/nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590818; c=relaxed/simple;
	bh=ruWjBdzuagaGirM9C6g0N/clfsaT89ub+b7Yh3IN52o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBzdb0+O0dPALl0x0A8YrAEuxgbfN62mlOhlVakrBvpOWw/87/mBl/gaxd8p7cAsoj4W7SVJTPJsA/FEuTlmCrjhlaU/mlJ+4R46QfeVoqnIxf2ALU9mwLVJAlDthgF4tI9uxiF0zIyPDASgEsqDL1k4r6v/BwsvwgeG+Kxf71I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scP0WJdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scP0WJdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901DBC4CEF1;
	Mon, 27 Oct 2025 18:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590817;
	bh=ruWjBdzuagaGirM9C6g0N/clfsaT89ub+b7Yh3IN52o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scP0WJdc++xx5GL48trTKNQ6oF7HuDms6xtzWU7F8ZmcMMeeMQOrPWk848cwcVEqq
	 7fzcjTqIV9WEJ7pqiG+B7NZBF2yOJPDMON5DTymEDrtSyp1k0UDeiTOds1Gboh9bXE
	 yHFteLG8SnBHITIMl3wU9T8vrMtl2a/jXX4L59GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/224] net: netlink: add NLM_F_BULK delete request modifier
Date: Mon, 27 Oct 2025 19:35:32 +0100
Message-ID: <20251027183513.821134693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 545528d788556c724eeb5400757f828ef27782a8 ]

Add a new delete request modifier called NLM_F_BULK which, when
supported, would cause the request to delete multiple objects. The flag
is a convenient way to signal that a multiple delete operation is
requested which can be gradually added to different delete requests. In
order to make sure older kernels will error out if the operation is not
supported instead of doing something unintended we have to break a
required condition when implementing support for this flag, f.e. for
neighbors we will omit the mandatory mac address attribute.
Initially it will be used to add flush with filtering support for bridge
fdbs, but it also opens the door to add similar support to others.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index cf4e4836338f6..9ad4c47dea844 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -72,6 +72,7 @@ struct nlmsghdr {
 
 /* Modifiers to DELETE request */
 #define NLM_F_NONREC	0x100	/* Do not delete recursively	*/
+#define NLM_F_BULK	0x200	/* Delete multiple objects	*/
 
 /* Flags for ACK message */
 #define NLM_F_CAPPED	0x100	/* request was capped */
-- 
2.51.0



