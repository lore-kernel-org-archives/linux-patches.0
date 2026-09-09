Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D0C58B6A7;
	Wed,  9 Sep 2026 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963510; cv=none; b=nO7tocyJQt50b45hR46DgwL4d4MMpqai/EWrySGKvC//bL32A9JktWnJEfrtXS19C8tGtux5iBtNxofaftAfX/BFHWkjib9/NC6xhX7A+fHfnvjrK1GsLxbnQ7rfUUxSnIUAQ4/EUUMUoMVZHrWdh+JIPXjuqJFEiDcdkZYIjIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963510; c=relaxed/simple;
	bh=psjWHfL5HDMt2twMfB6lfu7c4A4MholdaDGLM8Fua1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuZaCgP6rK3uDD18a4KSLYS+Ql82/pndx12q1xJ0B4u0hJMmK+Ju6lSUGQe9YysFhQ7CNDnHCp6ldPg1Tp6XRkMs1QtUAjMJ66yIBXuqEe0cP6Q2Srii2CGJ3ACRq1Ra4HTA7mkHeMDWiq5HuPI433AO0TOKvWd8rnH/ihjnHaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0f8h8Lz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0f8h8Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC291F00A3F;
	Wed,  9 Sep 2026 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963508;
	bh=OaJHyuEPMjw4oasdA1OCIv+BJG71PS3PqxsJx4KX2Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0f8h8LzTJ9H1VhkO63LV9BAlrLPiG7t4cfF+Auc37PIeWPnFNLEg5tjjywNk7/o8
	 FxnF2whNIJDuhJM/Q3pcpgW6Aao/e6VyX6KqeDiMW7Xz+I27sk94IRda6lBNj46euW
	 SrX2kOtznUuIUo5LTJ2UhyLvNW0Y6rtbHRwm0xqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 103/583] ALSA: rawmidi: Return the error from snd_rawmidi_input_params()
Date: Wed,  9 Sep 2026 15:36:28 +0200
Message-ID: <20260909134241.699535395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit f4a23e17d84fd2a152d9e12369761934e1af0ee8 upstream.

The snd_rawmidi_input_params() computes err for the three invalid mode
combinations and for resize_runtime_buffer(), applies the new framing
and clock type only when err is zero, and then returns 0 anyway.  A
caller that asked for parameters the kernel rejected is told the change
succeeded, and the substream keeps its old buffer.

The open_mutex conversion turned the early returns into assignments.
It handled the output sibling correctly, which still returns err, and
left this one behind.

Fixes: 94b98194b62e ("ALSA: rawmidi: Take open_mutex around parameter changes")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260902125058.19499-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/rawmidi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -782,7 +782,7 @@ int snd_rawmidi_input_params(struct snd_
 		substream->framing = framing;
 		substream->clock_type = clock_type;
 	}
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(snd_rawmidi_input_params);
 


