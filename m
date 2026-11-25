Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623144;
	b=jPfDcJ2Zpezw+qft5VYThneLY4jMJnbLFx/LaINickP8BVm0cHG7DTzEAb3FtmVr0E9c
	 ANFh7NTkFJX66u/22bmRDExpf0ZzWEUl4kc8gc77I/TMwR4Syo3/N1fy6rMgUUxGI0AqK
	 67kQ5RP6cb+MniuCGdoaiavaI2nmO2QTrdgsggjD1Sb7MhMEOGd1q6FMMxyEDeGbrRG9i
	 s3ZQ0pUTLeU/HL2io3O4fCyQJ/R7V63p9Ks6zVQDbnSG/4yTPbZRWGh58DeRKUB61vLrv
	 FIdZtC7W52qnps7gOAFH33DIb+MsLwI9/puOQzcpnElZEscLVfQ/7Wbj286HPNMZITw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1XRVto0S/+nmOIege+3cpISjD9z3AhvR+wXD6teQn1A=;
	b=FwoSZr0OcrqHBTyj0fjIV/rNVPwxRNv1/15Sx+/VXYsJps1TAQgXi2j+gtm0p3KM3t0V
	 9frWP+OvaAXfLUhCaQpkIkSOvWqpxFCftAvcgthTFdOSCQf10MT8mP6m47vazmu34RpDm
	 EeGnhnSTdA95MuItezFz0/70C85KI4901mtMi8uUfGV9jfB7Q8+Y9S4YjoOhe4wzTLwn+
	 9ao1188g6cIN8Oq6ucU/u9sRawgB7sSKJ+eMCzE1STg7GPfR0LYvBKK89OOhkuQL4NKZ2
	 NWdEllXwZHqQOMK7eG0HCWHrKC1Vw8NzknBoh0CLeIo3UO+wfUo+IQ8u5Q/Y6CvsNdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEpG2Dfv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FEE606A31E;
	Wed, 25 Nov 2026 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEpG2Dfv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892BD1F000C4;
	Wed, 25 Nov 2026 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623144;
	bh=1XRVto0S/+nmOIege+3cpISjD9z3AhvR+wXD6teQn1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEpG2Dfvm/tG19QNNDDcdMXS5T9s/gTjdpcWXTzDjzd3V/5Zy2bKx/BpMnkTXHcM1
	 ISeBgcwfFgWuWi2RK5aNZjdgEnpbZOB99+AlWc4o1fgLynpCVrKzmTj0QCIAffeFrk
	 kgHzo6XMuil8oVQfqtLdI71wEyZfyopFjyHkYrYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoli Zhang <baoli.zhang@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 738/990] ASoC: SOF: ipc4-topology: Fix pin format leak in process widget setup
Date: Wed, 25 Nov 2026 15:35:05 +0100
Message-ID: <20261125143839.354204734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoli Zhang <baoli.zhang@linux.intel.com>

commit e5c09fe3f9c8d9da33b177ee432db15b6ab46884 upstream.

sof_ipc4_widget_setup_comp_process() allocates the input and output pin
format arrays via sof_ipc4_get_audio_fmt(). When the following
sof_ipc4_widget_setup_msg() fails, e.g. because the firmware does not
provide a module matching the widget UUID, the error path jumps to the
'err' label, which frees the process struct and clears swidget->private
but skips sof_ipc4_free_audio_fmt(). The arrays are then unreachable and
are reported by kmemleak:

    sof_ipc4_get_audio_fmt+0xc9/0x420 [snd_sof]
    sof_ipc4_widget_setup_comp_process+0x8e/0x200 [snd_sof]
    snd_sof_load_topology+0x71a/0x840 [snd_sof]
    sof_pcm_probe+0x77/0x120 [snd_sof]
    snd_soc_component_probe+0x21/0x60 [snd_soc_core]
    ...

Jump to 'free_available_fmt' instead, as the other process widget error
paths after sof_ipc4_get_audio_fmt() already do.

The other IPC4 widget setup functions (pga, mixer, src, asrc) free the
audio formats in their common error label and are not affected.

Fixes: f9efae954905 ("ASoC: SOF: ipc4-topology: Add support for base config extension")
Cc: stable@vger.kernel.org
Signed-off-by: Baoli Zhang <baoli.zhang@linux.intel.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261109005604.1004362-1-baoli.zhang@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1205,7 +1205,7 @@ static int sof_ipc4_widget_setup_comp_pr
 
 	ret = sof_ipc4_widget_setup_msg(swidget, &process->msg);
 	if (ret)
-		goto err;
+		goto free_available_fmt;
 
 	/* parse process init module payload config type from module info */
 	fw_module = swidget->module_info;


