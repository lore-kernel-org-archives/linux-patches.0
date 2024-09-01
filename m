Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D2417ADE1;
	Sun,  1 Sep 2024 16:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209937; cv=none; b=N4HwrnlX5V7QeCYgYFng4v15JywkvG6YsKvPScERMI3MFYIeotYO4lcBpfAqPNi+y7ZSlzFAwV00HmbckkA6g+tRKJQaTQRbjnWnhqhSbPZbz4XxXQVPa0kStI8Th3ghkANyuDNrk4eAtRA7AqSCHD6jgSvB9/GAUxm6iAsHFM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209937; c=relaxed/simple;
	bh=6X5xUf49DE7E3OLXU2Mhh1vuHDuXovPLR05YLise/+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSUMLGnkES15Wb1C5uANzMdjz3/RXIEwUXSCZ4HZVBlAd2+uRdD5EV8NeiUgfy9mznTtXUS31MJFUYYNd4GNn7tADhCnWnTw3TDpm1Fd3BEtFxxcazRezqny2uEkddByLoF2NB9lCmlIU4tV6XR/gYuKfBCMOfRVr0UI7fre1RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxseVqmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxseVqmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C59C4CEC3;
	Sun,  1 Sep 2024 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209937;
	bh=6X5xUf49DE7E3OLXU2Mhh1vuHDuXovPLR05YLise/+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxseVqmLEJQAjse6xbiMZUOvEAr5Yhpu6s9dqeDozYHLI4FAAphzSIbQNGhmhvcG5
	 lB+WMPlkH925YjwbYEd0yI2cuGBbnnVyFe+7Vvg/VRYCo1xCXsbfpkBYz/cKGq7hsy
	 XZzxSWE0fEJHHd2yuxhWEdLXqtK9+BtuudKNxnpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 008/215] thunderbolt: Mark XDomain as unplugged when router is removed
Date: Sun,  1 Sep 2024 18:15:20 +0200
Message-ID: <20240901160823.554816293@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2877,6 +2877,7 @@ void tb_switch_remove(struct tb_switch *
 			tb_switch_remove(port->remote->sw);
 			port->remote = NULL;
 		} else if (port->xdomain) {
+			port->xdomain->is_unplugged = true;
 			tb_xdomain_remove(port->xdomain);
 			port->xdomain = NULL;
 		}


