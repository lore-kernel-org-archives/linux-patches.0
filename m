Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA071C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DF1C433D6;
	Wed, 23 Nov 2022 09:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194725;
	bh=o1ead+5rBVTZ7mRzhCWAICO6KlZSC0g7GmAHxAPXBbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onkouguH3VlyMRkL3oZcwg16ACQLNrfrBIWl5RQpL4UbQF1gvKXJnTRI8OjD9+n3E
	 KmSvFbrv3ZmAMyBeB8U5GPNH4WKvPMqECCidd+o9VJOikcvtON/w59wvNbfXrfdDGp
	 LDdSZin05pBVgnO+yJZvBCMLWASmDZ20fVJdSKPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 044/156] ALSA: hda: fix potential memleak in add_widget_node
Date: Wed, 23 Nov 2022 09:50:01 +0100
Message-Id: <20221123084559.500047445@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ye Bin <yebin10@huawei.com>

commit 9a5523f72bd2b0d66eef3d58810c6eb7b5ffc143 upstream.

As 'kobject_add' may allocated memory for 'kobject->name' when return error.
And in this function, if call 'kobject_add' failed didn't free kobject.
So call 'kobject_put' to recycling resources.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221110144539.2989354-1-yebin@huaweicloud.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/hdac_sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/hda/hdac_sysfs.c
+++ b/sound/hda/hdac_sysfs.c
@@ -346,8 +346,10 @@ static int add_widget_node(struct kobjec
 		return -ENOMEM;
 	kobject_init(kobj, &widget_ktype);
 	err = kobject_add(kobj, parent, "%02x", nid);
-	if (err < 0)
+	if (err < 0) {
+		kobject_put(kobj);
 		return err;
+	}
 	err = sysfs_create_group(kobj, group);
 	if (err < 0) {
 		kobject_put(kobj);


