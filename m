Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F319843F085;
	Mon, 17 Aug 2026 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979892; cv=none; b=K708WJuruQI1FTO9kdTyWjQOMap6kN1nszdectvC6U7yvRISUNScOhL7CZ7WCaMq+Cg3ZaVsNyNNl7ugZ4D1KgWFzWmmXdfja6yEyLzxjbMzm3/osdg2qByGSnFBcGTJ4Atvl4S9jz3BaMu726hkzw5yk0U3cII7KqPVYJoWWn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979892; c=relaxed/simple;
	bh=emO/BXN71UH9qzeT4t5TZJ568ReZMbCIj+lJA4+NFwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfOmkBP1SBEWlNvXikUw74O6BES01NchfV2t5JqDlTsq4Dj3jRTi4Y4UE41QkmlnEi5zKExlo7VwZFcofdAhPp5W/dQWJQscr6d823RhhwWYINyZHXRl82Bpfg5C7zj3GFwOT/y3mIQ4kN+K9pcfIw0UlAGxs99/5nRTPJC14L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znEPm4A2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znEPm4A2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC351F000E9;
	Mon, 17 Aug 2026 15:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979890;
	bh=vU47eslNBgZHCWMW3wvKRIJC7sP6Pd5IW2d96y4gNBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znEPm4A2nKO3sUEz+91VjT9IDSLm2oumZL+1W/k4WhZqxL9QqQMtomfEAXv3oNIc6
	 /AG8C2OJScXV8LBl9phq4v5varCeU8h2H0UdEPyAMPpxIp5t9LQu4pepISf4ORcS4A
	 XScNURuCc/kaFwbhQb2NoXdpXa9leyRRDGkSNe/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.1 383/609] pinctrl: devicetree: dont free uninitialized dev_name on error path
Date: Mon, 17 Aug 2026 15:31:19 +0200
Message-ID: <20260817132557.073647564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


