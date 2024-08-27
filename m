Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A031C9EAA;
	Tue, 27 Aug 2024 15:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771844; cv=none; b=mlPwLLbq+SdfJS6dyPLDoaa0OfVmrXl/J/F/Q3wScC9BksWnnUJGNei1CrQejuGPjWnmMMncH/kQucGqhS4+I/fHRhH/NhA/9Ki7buy/yDYG+GSz67W3yC51+Almr861Qz6zLVZNVUXZIwuBl6/d4FJRt6vJ9vYIyglDOtJaGCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771844; c=relaxed/simple;
	bh=sR8w9Rc71oUBMG4OM1K4idhH2+bqai5TWXcfWWOQctQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVO3FVvNFDXt9WD/NfEIOs7P0BXK40Z6njVr7cQlSOkMOdCoyOVCsbjpiesDRFXKReb2KdNPCiSTOrtsJV5yTejvPzPuHMimoIJxYll3qmau4Ye8o+h2GQEz/X5HKRpwiF/+eFRAH/L8oBi/C7owpoEcAErg/D6DF6OKmnEFBT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqyiI+si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqyiI+si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABEBC61044;
	Tue, 27 Aug 2024 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771843;
	bh=sR8w9Rc71oUBMG4OM1K4idhH2+bqai5TWXcfWWOQctQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqyiI+siEkOsAQdrMNOWruWQoHR23eWzndo0SEzxhzV3YXSgVf7V47YB0+fJ4C2It
	 +MgT43GIsuC+sQfw2ucB4oaUnKVW4rnaoTV/HPmU3ZAMv9uUUfsZ0ZKyew9DBv07TS
	 5IwnGy34Fu3Co/xWGgz/7xyZqDhj91VSKbz5N4gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 009/321] thunderbolt: Mark XDomain as unplugged when router is removed
Date: Tue, 27 Aug 2024 16:35:17 +0200
Message-ID: <20240827143838.554013789@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3086,6 +3086,7 @@ void tb_switch_remove(struct tb_switch *
 			tb_switch_remove(port->remote->sw);
 			port->remote = NULL;
 		} else if (port->xdomain) {
+			port->xdomain->is_unplugged = true;
 			tb_xdomain_remove(port->xdomain);
 			port->xdomain = NULL;
 		}


