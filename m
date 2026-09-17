Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EF04E77FF;
	Thu, 17 Sep 2026 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669113; cv=none; b=Qobn1eiPKoVsAj7+GLjP5BmHBjV/nfe8Ufl+c471YZIEA2AQmAY8AmqSYUoU8gjJ87I9mssRUUim4k/i3tQh6Hdu7Z6T+W/4LmKS7ExF6I1KLStMjvcmGgGAwu1lEU5PrsOJL6PfOjVD05FIUVAn/s1bx33desBWWyqX8Xv36xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669113; c=relaxed/simple;
	bh=wI1Qxwk6f1ruBEXxg7FpOVj6hh5YqH9Fwl1uSWsi2LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsfVuLPqmx5g9j1MC9tKwDWbtlsDEdB/3L/bPCV6D1hIXTkaIjZSFyJa1+VusCtN8eEjCfOGs43+ywL2XwVqyMa6n1lupu5z22spd3F6wubvPvEXrn14P0aEWlpF1l8lIIKZmFzzpVCz02uX0/zasDjlrpJzU8okHcWIC9jGAZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExIvoqxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExIvoqxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0E11F000FF;
	Thu, 17 Sep 2026 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669111;
	bh=dIEeDKPJvPB1tzs6SU6bxOn0YDhNK+q1CpQzuiTsfZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExIvoqxt+otvx+q+XwVrIfIjDB9bsnC1ZKBq0rUGy4MxQwrTn5dLkqFjmN3xRAR9n
	 a9Byjlf0T3DmeYFd2zuds8N2xiBSLZUxC5S6ng0Hf1bocTVdfeZx7MrPiqJN24qpKy
	 wsbhBQ1qmQ2BpiA9pKXt+xEYQVbtuEd/CIGu+jNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0601/1102] ALSA: ump: Copy FB name string more safely
Date: Thu, 17 Sep 2026 16:09:04 +0100
Message-ID: <20260917151555.092490026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e3f035edadcc1c5901311c03d098bc3dedc5c525 ]

The UMP group names are referred as the corresponding sequencer port
names, hence they should be proper ASCII strings.  OTOH, the UMP group
names are composed from the UMP FB strings that are received from the
device; i.e. a device may give some bogus letters and we can't trust
them fully.

To assure that the group names consist of the proper ASCII strings,
replace the normal string copy and append operations with special ones
that strip the non-printable letters.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250110155943.31578-5-tiwai@suse.de
Stable-dep-of: adeee7187694 ("ALSA: ump: do not touch legacy_rmidi before it exists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 912e1e23b7e51..d7d82ccfa6e3f 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -53,6 +53,34 @@ static inline void update_legacy_names(struct snd_ump_endpoint *ump)
 }
 #endif
 
+/* copy a string safely with stripping non-printable letters */
+static void safe_copy_string(void *dst, size_t max_dst_size,
+			     const void *src, size_t max_src_size)
+{
+	const unsigned char *s = src;
+	unsigned char *d = dst;
+
+	if (!max_dst_size--)
+		return;
+	for (s = src; max_dst_size && *s && max_src_size--; s++) {
+		if (!isascii(*s) || !isprint(*s))
+			continue;
+		*d++ = *s;
+		max_dst_size--;
+	}
+	*d = 0;
+}
+
+/* append a string safely with stripping non-printable letters */
+static void safe_append_string(void *dst, size_t max_dst_size,
+			       const void *src, size_t max_src_size)
+{
+	unsigned char *d = dst;
+	size_t len = strlen(d);
+
+	safe_copy_string(d + len, max_dst_size - len, src, max_src_size);
+}
+
 static const struct snd_rawmidi_global_ops snd_ump_rawmidi_ops = {
 	.dev_register = snd_ump_dev_register,
 	.dev_unregister = snd_ump_dev_unregister,
@@ -565,16 +593,10 @@ void snd_ump_update_group_attrs(struct snd_ump_endpoint *ump)
 			}
 			if (!*fb->info.name)
 				continue;
-			if (!*group->name) {
-				/* store the first matching name */
-				strscpy(group->name, fb->info.name,
-					sizeof(group->name));
-			} else {
-				/* when overlapping, concat names */
+			if (*group->name)
 				strlcat(group->name, ", ", sizeof(group->name));
-				strlcat(group->name, fb->info.name,
-					sizeof(group->name));
-			}
+			safe_append_string(group->name, sizeof(group->name),
+					   fb->info.name, sizeof(fb->info.name));
 		}
 	}
 }
-- 
2.53.0



