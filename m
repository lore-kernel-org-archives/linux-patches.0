Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434BA1DF726;
	Wed,  6 Nov 2024 12:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895727; cv=none; b=eh1CtUzKHmXj94g/CzEnH/n/gEiXLx6+YhC+7BYZoOfuKKeh1G2hAEo8JE9T6nuqiTq5LrSyEV0kSWpc+QX2jlgzX2EjA58k1sRY+gBidpt3lsrMjXHTX6ESRnSyWsZFKYipKPwTfI3q7Z4nr94w/mk4yz4Pe8siasvbJi+7xo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895727; c=relaxed/simple;
	bh=pV+g58PjaJCMXvlL08GQTD4H5vHBba0OVhPTW0iyk18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leAp2SvJk4OqVkD4DKMfIs7QNUkXLRVCPW2W3UiIl3r3hOaX4TD7dPXEUaTVUVS77j4/VYl8JPV2nLSJzVS3wH7Vk5+c7xUtWB5bGoErqJY5POP6GWdB1gWu33RWYH+6gAimwkuOgK10SBTWq2t3Eh80PWOBPMXympW9n8Znzqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewWyTv2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewWyTv2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC831C4CECD;
	Wed,  6 Nov 2024 12:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895727;
	bh=pV+g58PjaJCMXvlL08GQTD4H5vHBba0OVhPTW0iyk18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewWyTv2g0jTLz4nbxvYk+eW/DW0nub7XEU20y7+gqztbvJz0AUChq4g0QYtps5cYn
	 TTUdcfEHdYS1kmrSCc2giaEzMvByFdDKBf085rrGGqq+EpXVTlLSji2wNkfiZupdlE
	 U9qGUxmn1JulmtuPiMvjW827pdzAvufbQb1IoGG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 288/350] parport: Proper fix for array out-of-bounds access
Date: Wed,  6 Nov 2024 13:03:36 +0100
Message-ID: <20241106120327.951701994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 02ac3a9ef3a18b58d8f3ea2b6e46de657bf6c4f9 upstream.

The recent fix for array out-of-bounds accesses replaced sprintf()
calls blindly with snprintf().  However, since snprintf() returns the
would-be-printed size, not the actually output size, the length
calculation can still go over the given limit.

Use scnprintf() instead of snprintf(), which returns the actually
output letters, for addressing the potential out-of-bounds access
properly.

Fixes: ab11dac93d2d ("dev/parport: fix the array out-of-bounds risk")
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240920103318.19271-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parport/procfs.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -51,12 +51,12 @@ static int do_active_device(struct ctl_t
 	
 	for (dev = port->devices; dev ; dev = dev->next) {
 		if(dev == port->cad) {
-			len += snprintf(buffer, sizeof(buffer), "%s\n", dev->name);
+			len += scnprintf(buffer, sizeof(buffer), "%s\n", dev->name);
 		}
 	}
 
 	if(!len) {
-		len += snprintf(buffer, sizeof(buffer), "%s\n", "none");
+		len += scnprintf(buffer, sizeof(buffer), "%s\n", "none");
 	}
 
 	if (len > *lenp)
@@ -87,19 +87,19 @@ static int do_autoprobe(struct ctl_table
 	}
 	
 	if ((str = info->class_name) != NULL)
-		len += snprintf (buffer + len, sizeof(buffer) - len, "CLASS:%s;\n", str);
+		len += scnprintf (buffer + len, sizeof(buffer) - len, "CLASS:%s;\n", str);
 
 	if ((str = info->model) != NULL)
-		len += snprintf (buffer + len, sizeof(buffer) - len, "MODEL:%s;\n", str);
+		len += scnprintf (buffer + len, sizeof(buffer) - len, "MODEL:%s;\n", str);
 
 	if ((str = info->mfr) != NULL)
-		len += snprintf (buffer + len, sizeof(buffer) - len, "MANUFACTURER:%s;\n", str);
+		len += scnprintf (buffer + len, sizeof(buffer) - len, "MANUFACTURER:%s;\n", str);
 
 	if ((str = info->description) != NULL)
-		len += snprintf (buffer + len, sizeof(buffer) - len, "DESCRIPTION:%s;\n", str);
+		len += scnprintf (buffer + len, sizeof(buffer) - len, "DESCRIPTION:%s;\n", str);
 
 	if ((str = info->cmdset) != NULL)
-		len += snprintf (buffer + len, sizeof(buffer) - len, "COMMAND SET:%s;\n", str);
+		len += scnprintf (buffer + len, sizeof(buffer) - len, "COMMAND SET:%s;\n", str);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -128,7 +128,7 @@ static int do_hardware_base_addr(struct
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += snprintf (buffer, sizeof(buffer), "%lu\t%lu\n", port->base, port->base_hi);
+	len += scnprintf (buffer, sizeof(buffer), "%lu\t%lu\n", port->base, port->base_hi);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -156,7 +156,7 @@ static int do_hardware_irq(struct ctl_ta
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += snprintf (buffer, sizeof(buffer), "%d\n", port->irq);
+	len += scnprintf (buffer, sizeof(buffer), "%d\n", port->irq);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -184,7 +184,7 @@ static int do_hardware_dma(struct ctl_ta
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += snprintf (buffer, sizeof(buffer), "%d\n", port->dma);
+	len += scnprintf (buffer, sizeof(buffer), "%d\n", port->dma);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -216,7 +216,7 @@ static int do_hardware_modes(struct ctl_
 #define printmode(x)							\
 do {									\
 	if (port->modes & PARPORT_MODE_##x)				\
-		len += snprintf(buffer + len, sizeof(buffer) - len, "%s%s", f++ ? "," : "", #x); \
+		len += scnprintf(buffer + len, sizeof(buffer) - len, "%s%s", f++ ? "," : "", #x); \
 } while (0)
 		int f = 0;
 		printmode(PCSPP);


