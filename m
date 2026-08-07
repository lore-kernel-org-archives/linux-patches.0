Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091043F3280;
	Fri,  7 Aug 2026 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113786; cv=none; b=RnlZmvpk+N5wAkUucJrQ/cbF1gLvAnFSwY6R5Gv8SXuMIgNUhi7E2KmKjmlEX7Fjoi8vajQqh6q0kydFkOSMdG5WqbDHRwZkC9CNJw4KaHGvc+hQ2xcla4ApMZgkCM2rcCGDDkzCpOdijKhOSHrMCK1T6oGUPzvhRuUp5uutzgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113786; c=relaxed/simple;
	bh=Myv6S6LwQs7a0c1W2Mn1OcCS37BfdUxQZNDDFQrFQ64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWeK8NnTjbhiT2a4qmFwDCZVYoyXOcbLd27lWoAmQIMd9Gs0W3SoP/a/5jglk1/YkqMZCbAXjb146foN3PbMOr42TDT6SgvUxkUluEjFH2N79+R9wR+GvwBkx4fnPDJ/7Ku8bzXWq4B1M5UF0mGSJLpKTlSEuyVRVXP1uGObcu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wo+Iw4NL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wo+Iw4NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB881F00A3A;
	Fri,  7 Aug 2026 14:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113768;
	bh=BqBdjDR2jUOksSY3Ro4jWWPLCCMdz1uNbm0ZHIt6X8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wo+Iw4NLu7yfc8LNBXZ4SmuDpWUNdY8Z2ipc7W+UmHlZmVVAHiaSLRW/6wmwrB8FG
	 KBzf8uqZ8TdAa/yd5CyHtHXbbqpEBE93PIiztozOuGLuDwkbecD3zRTlSbdfMHvTEN
	 W7ddlkD7juzLo3rvy1mK8vGxPKdF92bCj+7go60w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/337] um: Set parent-death signal for ubd io thread/process
Date: Fri,  7 Aug 2026 16:33:28 +0200
Message-ID: <20260807143418.638333993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

commit 9b5e6c0f5a9199c69af81ac5bedc512ee7dc20b3 upstream.

The ubd io thread is not really a traditional thread. Set the
parent-death signal for it to ensure that it will be killed if
the UML kernel dies unexpectedly without proper cleanup.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241024142828.2612828-3-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 2bfb17373244..66c1a8835e36 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1501,6 +1501,7 @@ int io_thread(void *arg)
 {
 	int n, count, written, res;
 
+	os_set_pdeathsig();
 	os_fix_helper_signals();
 
 	while(1){
-- 
2.53.0



