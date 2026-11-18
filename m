Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022405;
	b=33iJuanalyM/OlhtlXdxBMG3zRgGraRl4M6oVjR6HurSq74eHvO23ZjQvJqWKW05vyGz
	 FwKOBkto5OAYylH+zdK6xJOsq0hdEwPPFc/oED9HyPxTBW5+s2CjktyFLZmnYUnUnf7RF
	 0hIqsnOgnt5EImLT/+VR9yZcNsq3ozMZM77/Qe4Vclw7MDmy94htZHYLU0YODoSEW0Cuq
	 +nbqdGrvLGy5d7MaX3vLlNiNwNT0xCBvLl5uk+3yNtPaYaMFW9xvGCDiHv7otJ11k5323
	 jFYU6mTNKgzi7im3b4/8LZae4Oq7Db9uLk/nWOOwC9OwXKvsplqTiBwL7/SRnevXw7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x72t8TRodl6iPUaBjuC7vG+5E/oarVo0wB4ygqfIYxo=;
	b=UOI5YUHEMjffcF+xugmW82zzjTDrxj+AlgnnogauUf0ozmDYSCtubVHTUCGBuYeTRQda
	 fG5rVtmmUfPEuIBGBU/tVlvLORXJgpDfQnvPbssiW/63tguFwVT0k2zSr+JtBNsSW6/DO
	 N5hzstqqS19bhGjmxfCWtf5z78OCcBi4iYwjTmHLhdrqR6Y3rSvlakFc5w3OXtlZ9RqOC
	 9v1n+m7vM8CrcxVQgU+bj8IzBNNrMlirvAnkqfV7KDyS5newsdLH3LCxsE2OpOh1wAmo3
	 5hI2523QFNkhLi8AHCssATfrCxBku+hm+4B2/AcogMIlQsxpqfDEt6WuQJmXiyCNdUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NQmA8/t/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB599606A320;
	Wed, 18 Nov 2026 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQmA8/t/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F61D1F000C4;
	Wed, 18 Nov 2026 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022405;
	bh=x72t8TRodl6iPUaBjuC7vG+5E/oarVo0wB4ygqfIYxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQmA8/t/9g+a2G56o7xSwpXs8AmpnvBWdR9ma27hfvz0prFefR8Tz9MEu2OXPcmsl
	 vt8gvTKq/MMFc4T/CwhtjrTMktdup+LNg154y4ZXq9YipJTc5a5XeKuImcogVHPjF3
	 gdn3LjNmnbdX1suQN/8K6B1uYdjH5AW28dPY6oPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.3 2650/2651] PM: runtime: Only queue an idle check for RPM-linked suppliers (part 2)
Date: Wed, 18 Nov 2026 16:04:50 +0100
Message-ID: <20261118150419.454695901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

commit bd56424ce808fb1f92a4dc5bdeedc45b85c5d6cd upstream.

Commit be5755f023e7 ("PM: runtime: Only queue an idle check for
RPM-linked suppliers") was incomplete. There are two other cases where
we perform idle checks on non-DL_FLAG_PM_RUNTIME suppliers -- in
pm_runtime_set_suspended(), and in cases where we failed to resume
suppliers.

Fixes: be5755f023e7 ("PM: runtime: Only queue an idle check for RPM-linked suppliers")
Fixes: 5244f5e2d801 ("PM: runtime: Defer suspending suppliers")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/20261103141442.v2.1.If69ddc515c2e9fd4338441e87688b9d690d2ef36@changeid
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -343,6 +343,9 @@ static void __rpm_put_suppliers(struct d
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
 				device_links_read_lock_held()) {
+		if (!device_link_test(link, DL_FLAG_PM_RUNTIME))
+			continue;
+
 		pm_runtime_release_supplier(link);
 		if (try_to_suspend)
 			pm_request_idle(link->supplier);


