Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DD63CF045;
	Fri, 15 May 2026 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860986; cv=none; b=Wsn0+5YAIyy9ydhhEAq5PafPOqwf6abkbFVIhEEWNcHzgNSh5A1WwGSweZtCv1E9C5PcN8ZVkv3UcHMNs5b8N93cLJmACJ84pf1+IneJLT6wbo+EoHuqJHxmaoax53+M/5og9dRq357willS5yky8xK/FHQx9IhomOn40Ne9BSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860986; c=relaxed/simple;
	bh=3HF4u8uQTnBQo5vLoFa/Mn9Fuqdvk3+Y+HTCXzFaIKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXEVfN5W1D4RRALPjwi0vJLtyaaSWIDCqWdFy5aDq6COD+AnDBofdlBxoHq6CrMbBce+9nkYa5XYF0OO2Zfg7oZdo7oOGllqGZcA0Hl4vtp4kB86ZSBCSaiUI7byPBD+LfZ2re8crsLToNPQgAnj9jMXeXzdmWqpT1oXtGIlRUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCUBnqGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCUBnqGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE989C2BCB0;
	Fri, 15 May 2026 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860986;
	bh=3HF4u8uQTnBQo5vLoFa/Mn9Fuqdvk3+Y+HTCXzFaIKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCUBnqGoeqBcPwOGRFN4l76AA+GkwheLBiiHnNy87+LnDVYuSyCH6l0rtFmKCihWO
	 IJYuqTAtzWdLATuG3lJnp1URbTj5UWShZHp/+tBJNCFvvxp9yembws6+nPbHDuh7pU
	 KHtC9dawsmUmtKdfrN7Arc+ht/hokbthdA1MDk2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 153/474] ASoC: SOF: Dont allow pointer operations on unconfigured streams
Date: Fri, 15 May 2026 17:44:22 +0200
Message-ID: <20260515154718.336683252@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit c5b6285aae050ff1c3ea824ca3d88ac4be1e69c8 upstream.

When reporting the pointer for a compressed stream we report the current
I/O frame position by dividing the position by the number of channels
multiplied by the number of container bytes. These values default to 0 and
are only configured as part of setting the stream parameters so this allows
a divide by zero to be configured. Validate that they are non zero,
returning an error if not

Fixes: c1a731c71359 ("ASoC: SOF: compress: Add support for computing timestamps")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260326-asoc-compress-tstamp-params-v1-1-3dc735b3d599@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/compress.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/sof/compress.c
+++ b/sound/soc/sof/compress.c
@@ -371,6 +371,9 @@ static int sof_compr_pointer(struct snd_
 	if (!spcm)
 		return -EINVAL;
 
+	if (!sstream->channels || !sstream->sample_container_bytes)
+		return -EBUSY;
+
 	tstamp->sampling_rate = sstream->sampling_rate;
 	tstamp->copied_total = sstream->copied_total;
 	tstamp->pcm_io_frames = div_u64(spcm->stream[cstream->direction].posn.dai_posn,


