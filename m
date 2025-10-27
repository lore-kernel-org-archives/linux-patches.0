Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFE431B824;
	Mon, 27 Oct 2025 19:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591935; cv=none; b=eX+hdl+jWVi4CjphbmL3kD731qjL9W4RX+j0vqRC+Sf6hADLiNnLunoAKEn7InMSKuOmkzPHcoRi1uOgfILlg4XRXLJ2Ae4JKyF6/SGLC17bJdeJhJbYVzgDfH1KWCxxMJNH213O0XfdCksr8050FPKxSH2z90ENTClLpmVv9/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591935; c=relaxed/simple;
	bh=18N5Oha+W2d3JdQ5Lx63BJDK1ZmgXqP+UBZ8lvcrko0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCfhBcC6p+dWpVbU3fAQ87Hc0dHOcoCSPzslgM/7sO1X/XNL1eyX5kCZcqFs4Ay5OIFOE+gYY/JokYvifakhhnTr8/rLTQdl8ulQzqM+IxauKkVc28EJr1u0dyXiQSc8fMe7U03yp+ONrWwIHVXnIJFup4ViZLcVIoPDf6i0qB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLvMH7pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLvMH7pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22607C4CEF1;
	Mon, 27 Oct 2025 19:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591935;
	bh=18N5Oha+W2d3JdQ5Lx63BJDK1ZmgXqP+UBZ8lvcrko0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLvMH7ppGjDWnCMlBqB+zeo5fgBZnaqQs/11XJ4rdaBuN7ApGNrj17wptxs1domWq
	 JHY7azOaYXKs1Om8jjJnrf+ALyEGyXOVj8n15ornK9zMC6IvdRjZy1ud4VyeJBjmFi
	 mOVMvVghkVkOsi9RwFFYZerMGNoO1zElvKina64s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/123] net: netlink: add NLM_F_BULK delete request modifier
Date: Mon, 27 Oct 2025 19:35:34 +0100
Message-ID: <20251027183447.841542832@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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
index 4940a93315995..1e543cf0568c0 100644
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



