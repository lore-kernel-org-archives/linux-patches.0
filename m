Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD01A08A3;
	Tue, 27 Aug 2024 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769855; cv=none; b=GojPUscG3MZL8x8z+zgk/QDaotFeYPcUPDtMo3vKw9ViEuMVxR39hNq706jdFnspxDhgtmCcEmxgWRnNYLNtdQx4sbIa0SwkTqaJzE+lYzq1X4rX8SEfGqcW8lE4Goci5vA0M3X1OLQ/QI9X+go7SomwMHH97aG5aBDAedw5Y5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769855; c=relaxed/simple;
	bh=uUgdvIdbr4Mixhpf85cR/Og9ML2jc/51LNLb+mlo/as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHIpeK19ZX3TAWqaKEGFm4A5/AT1tzdUr/kUpS9Bt841Q6DlTBIsRol7OIe8Hh9fdYIcVyjQyi4GltKJHZgYHghAk/hbpqyO0gEVo0lau1EBu07lkcuSMnfpoI8gKiYEnb9W0x6Bsm/DD4u7sYP0iMKcFiUeYIZzAAdl5lx9zfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqqkULZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqqkULZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6E6C6105D;
	Tue, 27 Aug 2024 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769854;
	bh=uUgdvIdbr4Mixhpf85cR/Og9ML2jc/51LNLb+mlo/as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqqkULZD9SoR+NVH+GkXicpJzOfHoPspfuIveAHwEicQDS5V59UijBTkJs5Zt9xfX
	 A8CDliW1mtLv1J4hFDmxymBXXAsNp05ZSdMh1hPB3Yv8ZeG8C9RuMhAeSD4Iw7ZMwI
	 NXWbt5iZuiBnetTBoGwCVtAIAmGCNt30P5ezn7n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 014/341] thunderbolt: Mark XDomain as unplugged when router is removed
Date: Tue, 27 Aug 2024 16:34:05 +0200
Message-ID: <20240827143843.947936784@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit e2006140ad2e01a02ed0aff49cc2ae3ceeb11f8d upstream.

I noticed that when we do discrete host router NVM upgrade and it gets
hot-removed from the PCIe side as a result of NVM firmware authentication,
if there is another host connected with enabled paths we hang in tearing
them down. This is due to fact that the Thunderbolt networking driver
also tries to cleanup the paths and ends up blocking in
tb_disconnect_xdomain_paths() waiting for the domain lock.

However, at this point we already cleaned the paths in tb_stop() so
there is really no need for tb_disconnect_xdomain_paths() to do that
anymore. Furthermore it already checks if the XDomain is unplugged and
bails out early so take advantage of that and mark the XDomain as
unplugged when we remove the parent router.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -3159,6 +3159,7 @@ void tb_switch_remove(struct tb_switch *
 			tb_switch_remove(port->remote->sw);
 			port->remote = NULL;
 		} else if (port->xdomain) {
+			port->xdomain->is_unplugged = true;
 			tb_xdomain_remove(port->xdomain);
 			port->xdomain = NULL;
 		}


