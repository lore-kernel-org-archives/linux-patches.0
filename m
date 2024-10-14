Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25ED1AAC4;
	Mon, 14 Oct 2024 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916043; cv=none; b=FyvudLG0hWgC7ux54ATy5OrLDVaZNkKcNY8PWCiXVsTrfEYhgMbdA38IiPrAvH9GDPo7lOgzqyCb5IAr8U8fEJmsDYyc61RnB3ygBVjeCLEoPF3uQwixrQsqaMkc36AuFYwf3tYdn9nah4CS4Z+H5qdwYbsi0cNTrd/upJMUYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916043; c=relaxed/simple;
	bh=ypg+ghyZQT+E4cz746VCCsk03jwm1gRu7f9P7Ixz9Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTHyf22LB2KWs0DGN8e6A/F+bk9BG5BN9558sWxnA8LOoVaZ5mYXL/BIppFJA4TXAB/lMEsxp9bmgynaheVPWdf1eKVGPfj/GpMXrZjTWfuhoOXEAB5+x10x912RpnelbE7fhiLD5fHSq6g6r06oGwqsNJPw4lfxxCOHBNG0lLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqwOCjHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqwOCjHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2382CC4CEC3;
	Mon, 14 Oct 2024 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916043;
	bh=ypg+ghyZQT+E4cz746VCCsk03jwm1gRu7f9P7Ixz9Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqwOCjHIlTQ/vSA/4S4iiCmE7mAYLJpCk52lMSA2RpbzH5O9qnQXP5AZTpBToVD/M
	 OseHg/JM0mYUdoXVqe6cGReploGO/gQjBXoThtqbLJpGqw9WC9HLr4hVZ6SJd+bR7t
	 4nGQObRpdjWWXnpZ+q0miIeeKRXghF8XR2nE9XI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 070/214] driver core: bus: Fix double free in driver API bus_register()
Date: Mon, 14 Oct 2024 16:18:53 +0200
Message-ID: <20241014141047.722045130@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit bfa54a793ba77ef696755b66f3ac4ed00c7d1248 ]

For bus_register(), any error which happens after kset_register() will
cause that @priv are freed twice, fixed by setting @priv with NULL after
the first free.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240727-bus_register_fix-v1-1-fed8dd0dba7a@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index ffea0728b8b2f..08362ecec0ecb 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -920,6 +920,8 @@ int bus_register(const struct bus_type *bus)
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&priv->subsys);
+	/* Above kset_unregister() will kfree @priv */
+	priv = NULL;
 out:
 	kfree(priv);
 	return retval;
-- 
2.43.0



