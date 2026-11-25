Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625769;
	b=fahiwoMUkAZsRwfkAI+pRryo0U0ooqbyPNjMYaRfDhNg8+9a+GVzOcR8VBZKC9oULm/L
	 R23/EXUYZ5lnilRPpeytfGpBSihK/FOP2BkQFAjq39Vd7DB5ieWpThpinS/ql9pVGHdIk
	 xXj+2MRfVi2+9xpTojmVHfuPcYfjfUFPyHnrRlywW7ajYvLhg+xFdGUF8cpC/sRfxWn/P
	 1UD+Bfi6HSzxOnnJ6FY79q+bLgjsWp1qGmMA+I+ruVwL+yGwi3BxTSssm7mkD46980RuX
	 F6FhqcVALECDx/zqbbdOfD/kgNYfARGtBNKLGUNSHXKVkY3Irr/HMgxgRmDLM/NhnSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GwiV28beGkYXB283CVTahbgxiFjDTq3N0Q0K7A0WOVs=;
	b=nq+Vq3TilbjSaCJVlhZ2AcdAmplchyK0IEz82o6shGwNKBTwpZrh8bvF3CtkVt3zuL5y
	 4PoDKKBJrwwQZgzmTGFAXR04YQznazmovYrZ4jc7jNYFmFolUkWtBhcb3GvJFZgblTeCG
	 T6KQ8UTNBU2N0q484D3BjPSEEPGUlLrpXwmIdyHpksVDptY7BTJKro4KGyO7XOHX6pbNV
	 864bARFwSVS9P9zBxgEikv1uDLh31jDt2xsAJIQTIdkR074/VkdChLNaAWGbXYGiUqLlE
	 POjoXbxmugNLQgku9mNWNczDhWZEHW4qXi3iQcxgCPFIGDs+yc2WN6rGcrPNw0j47aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfEel7fy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6D6606A333;
	Wed, 25 Nov 2026 16:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfEel7fy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667971F000C6;
	Wed, 25 Nov 2026 16:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625768;
	bh=GwiV28beGkYXB283CVTahbgxiFjDTq3N0Q0K7A0WOVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfEel7fyv4q89ldNlEDMRFVPEB4JUIIJPIFutaTd7qIQV1JYI1Ma56fCV0YGfVLig
	 Q2pXeVlMXh6kPVboHqJmQQCwgrm8+w4hdpsUfiKAB5EN1TAK0J8cUZ04ykMtNt6FO+
	 APH6wiYV29R4B7xvja1gbJs2atch8flnWuJIdjRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoli Zhang <baoli.zhang@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 609/816] ASoC: SOF: ipc4-topology: Fix pin format leak in process widget setup
Date: Wed, 25 Nov 2026 15:35:57 +0100
Message-ID: <20261125143903.275983202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1003,7 +1003,7 @@ static int sof_ipc4_widget_setup_comp_pr
 
 	ret = sof_ipc4_widget_setup_msg(swidget, &process->msg);
 	if (ret)
-		goto err;
+		goto free_available_fmt;
 
 	/* parse process init module payload config type from module info */
 	fw_module = swidget->module_info;


