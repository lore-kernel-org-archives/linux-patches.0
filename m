Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4083DDAFA;
	Fri,  7 Aug 2026 14:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114185; cv=none; b=Y83rqZauh/2H7Tcwc88oXba5JXjcoNMkYMR80Meua8PsKkwbbXPceRI8E6oDTSGjs0YBXdFCPIBJ65owr3asYFhsgfKDUGD850HEFqV3px+mD7aqySorKAsY0MUHGCOE0dhOkBmSJRXqw9nicL/F9iD92sEoJKsRSr+srsogp08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114185; c=relaxed/simple;
	bh=mwdKzcmn478oKGtovQDNiXqtdWAFZeV1CCZ4OLte+to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4KDgayKZxN2Wf6ijNTzfiJRafu5QCiVV2rV7DG8KNQEjEIsm3WPJcVw9+SmbFkxf4y62TWsKxidsRuJHVkDRJljgCzvxOlFKKPhS6GTSGk5RqgYZgOZqgqyXIN4cOvzWoVsMi0iBC62F8UBmu1ECt+wHMt6vY7yvxFELjm0BoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElZRV6hE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElZRV6hE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C131D1F000E9;
	Fri,  7 Aug 2026 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114184;
	bh=xtWEdQTyKdsQHCUCLfeEgS5mi4KW1E641CAblEnSFu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ElZRV6hEW5/bD2iXS9wu1ioAbD4IjgYqFKgt9PiCVRNPAj2DVPqiloG+4Vi8BeMjS
	 N3/jvdBtHztvGPwGATKjomI4E4YUelngJxD4tsE5Lf/TMH9/H6P5lb2Uq5YbqshMOg
	 1/e4wgWMZMRZc4cQqYXxELMeA+43eJCasr0IjE3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.12 130/337] pinctrl: devicetree: dont free uninitialized dev_name on error path
Date: Fri,  7 Aug 2026 16:35:33 +0200
Message-ID: <20260807143421.351053984@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 015b5bcbcb622b32317642be91a7f79aa5413649 upstream.

dt_remember_or_free_map() duplicates dev_name for each map entry. If
kstrdup_const() fails, dt_free_map() frees dev_name in all num_maps
entries, including entries that have not been initialized.

Some pinctrl drivers, including pinctrl-imx, allocate the map with
kmalloc() and leave dev_name for the core to initialize. The untouched
entries therefore contain uninitialized data which is passed to
kfree_const().

Reproduced on qemu's mcimx6ul-evk (pinctrl-imx) with failslab injection
while binding the pinctrl-consuming device, under KASAN:

  BUG: KASAN: double-free in dt_free_map+0x34/0xa4
  Free of addr c425a900 by task init/1
   kfree from dt_free_map+0x34/0xa4
   dt_free_map from dt_remember_or_free_map+0x184/0x198
   dt_remember_or_free_map from pinctrl_dt_to_map+0x33c/0x4c8
   pinctrl_dt_to_map from create_pinctrl+0x9c/0x5c0

Initialize all dev_name fields to NULL before duplicating the device
name, making the full-map cleanup safe after a partial failure.

Fixes: be4c60b563ed ("pinctrl: devicetree: Avoid taking direct reference to device name string")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/devicetree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -69,6 +69,10 @@ static int dt_remember_or_free_map(struc
 	int i;
 	struct pinctrl_dt_map *dt_map;
 
+	/* Initialize dev_name before any allocation can fail */
+	for (i = 0; i < num_maps; i++)
+		map[i].dev_name = NULL;
+
 	/* Initialize common mapping table entry fields */
 	for (i = 0; i < num_maps; i++) {
 		const char *devname;


