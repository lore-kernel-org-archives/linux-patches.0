Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ED33D5D8E;
	Thu, 15 Jan 2026 17:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499648; cv=none; b=PgXHDdSlbpZgiaBzqTTW79D3/6Asqgle0mIfK899DK2vXJMXUJGir14ekLBEw6Rk5+GbFPaKy6hRF6FU4Jq/rBUTX1W+AarHDJ/bn+qh8gwa6i4oQI/f+CK2UU4PztZlznUzAzn0yd4LWSKA/RIuBNcsClDr+NR1M3N37cWcjvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499648; c=relaxed/simple;
	bh=JQ1rN/n/gYMswNDMp5SrLyKnI0Ygx29jSQOwfKhInuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxBDipT7EsLfohJIkxcoBIa8RZFZOlHTZ+nNSsJDRLKJW7Ae9rXWXZ0+QJgKZGz82lI/rpfCFaw//uPGYhls4IWxaGer80I/kETk5wbksIQLb+M/Usekja7nX/EdditndpzMl1DwhxOmjz6Cc+O4CJAuFq4a1XCdbaD0qFc3HDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4JYvRws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4JYvRws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE49C116D0;
	Thu, 15 Jan 2026 17:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499647;
	bh=JQ1rN/n/gYMswNDMp5SrLyKnI0Ygx29jSQOwfKhInuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4JYvRwsWNfPfjZl0oYEb/IvPNBkkexxQOtf4aSEYz3szBbG8TtEs2vIWBrpZkJpR
	 elSo/Vc0gdNnfOhMEkTQwC67nj+JorqoKjMyJYBlO4KfECmdmnW5iPIpQuTDaFojsP
	 m9SUD9ymN0mV4OxRLQt0yko1LBpGzrusYXGWgp1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 5.10 299/451] ASoC: qcom: q6asm-dai: perform correct state check before closing
Date: Thu, 15 Jan 2026 17:48:20 +0100
Message-ID: <20260115164241.706947879@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit bfbb12dfa144d45575bcfe139a71360b3ce80237 upstream.

Do not stop a q6asm stream if its not started, this can result in
unnecessary dsp command which will timeout anyway something like below:

q6asm-dai ab00000.remoteproc:glink-edge:apr:service@7:dais: CMD 10bcd timeout

Fix this by correctly checking the state.

Fixes: 2a9e92d371db ("ASoC: qdsp6: q6asm: Add q6asm dai driver")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Alexey Klimov <alexey.klimov@linaro.org> # RB5, RB3
Link: https://patch.msgid.link/20251023102444.88158-5-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -237,13 +237,14 @@ static int q6asm_dai_prepare(struct snd_
 	prtd->pcm_count = snd_pcm_lib_period_bytes(substream);
 	prtd->pcm_irq_pos = 0;
 	/* rate and channels are sent to audio driver */
-	if (prtd->state) {
+	if (prtd->state == Q6ASM_STREAM_RUNNING) {
 		/* clear the previous setup if any  */
 		q6asm_cmd(prtd->audio_client, prtd->stream_id, CMD_CLOSE);
 		q6asm_unmap_memory_regions(substream->stream,
 					   prtd->audio_client);
 		q6routing_stream_close(soc_prtd->dai_link->id,
 					 substream->stream);
+		prtd->state = Q6ASM_STREAM_STOPPED;
 	}
 
 	ret = q6asm_map_memory_regions(substream->stream, prtd->audio_client,


