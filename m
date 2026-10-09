Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933E44D4897;
	Fri,  9 Oct 2026 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557530; cv=none; b=js5oGdapFrFskFSqZMrMmnKHbrd23L6Rl0WZFOxfWolCmT7aJJ73q4uq+RdHV3RQGQ+m/IJq4baWpOoATdR8oyCNxTmgoFxNe+5M+ueWd7/RSgm8Wh8u6iLdRV/RNEzgeVrzJk/YSmLzPUprOdGBiLILTyOE9wOQFI/7iOVev/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557530; c=relaxed/simple;
	bh=UP06Jy/HfeP2W+OkBMdo3mzSyKAN/Onjjv6qOl1wQ0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9jJ3s4TGfXKVy74FfARtXHDwntBSkgguB26Ef8iPLJ6Rv69BIZWRKf8rNWA3xRNP0K1PLygCEFMKUcpnQ36tsuQj5VST/kaXshon4AIwLZXwYErHpGh8/miilZ96BRYwveNxVCIf7g6TN48PGZuvqJyi4y65ySghq57V1wONp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYruMgUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYruMgUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D3F1F000FF;
	Fri,  9 Oct 2026 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557529;
	bh=wNGQiKK8+RKTTMQEqfgPhiyQgeMXeOSiQv5FC4k1LIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYruMgUTgrGLY/Cq+5mi7TXwkPP9o6d7grsLbZsROniF1L7eTpUUfsgpSdXVrJM5N
	 pUOUALDkiDO+mvFhgTgC7NjmQed9+RQa1ZqgihnOsCBo/IVpZe8Q57A6QeHtHBHEDa
	 hnoJU3HJr/k3kLVCTLrQkORlVk88wXRSTq4Wjl3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.2 353/428] thunderbolt: Mark discovered tunnels as active
Date: Fri,  9 Oct 2026 16:11:30 +0200
Message-ID: <20261009140953.921061360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

commit c222f80be55f6c17851af1c68a70ae4046c848e2 upstream.

Discovered tunnels that have been activated by whatever was running
before us stay in TB_TUNNEL_INACTIVE until hibernation restore such that
anything depending on tb_tunnel_is_active() skips them. Mark them active
during discovery instead. These now also emit TUNNEL_EVENT=activated
uevents during discovery.

Fixes: d6d458d42e1e ("thunderbolt: Handle DisplayPort tunnel activation asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tunnel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -507,6 +507,7 @@ struct tb_tunnel *tb_tunnel_discover_pci
 		goto err_deactivate;
 	}
 
+	tb_tunnel_set_active(tunnel, true);
 	tb_tunnel_dbg(tunnel, "discovered\n");
 	return tunnel;
 
@@ -1658,6 +1659,7 @@ struct tb_tunnel *tb_tunnel_discover_dp(
 
 	tb_dp_dump(tunnel);
 
+	tb_tunnel_set_active(tunnel, true);
 	tb_tunnel_dbg(tunnel, "discovered\n");
 	return tunnel;
 
@@ -2286,6 +2288,7 @@ struct tb_tunnel *tb_tunnel_discover_usb
 			tb_usb3_reclaim_available_bandwidth;
 	}
 
+	tb_tunnel_set_active(tunnel, true);
 	tb_tunnel_dbg(tunnel, "discovered\n");
 	return tunnel;
 


