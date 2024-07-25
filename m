Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F608468;
	Thu, 25 Jul 2024 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918847; cv=none; b=cz34OrOuCnvvJknnPcJTpPaKqagNexEELW1LLJz3r0/Au0zRBGZRCctSDVTP0NBxB5bhmt/qXTEP0fB5/NE1YsJmI5CRE7EJrxMO+lei2byeEuqSi8rR+j0AuQlNeynEtvQIPj/u838K+iasnmaW1hwkYCcaf0bo9BK/N7QgGvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918847; c=relaxed/simple;
	bh=RF9n2+mSRlFrkpFHMIEg3Z/dF+crOrSNrrqnNlfJyu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxnYbrmTcvnr60PSEUThhz7bhArjszCBB+UQlbQAg7u7dJTqS6DaG30AEV0s5JkM0YBJ6BIB1N2Iu372GQQ1quBGbR31XyJVFNOoUsfWOHU/huxKQEL9E43FZbreBquBvzBCnMbUaQZ4C7C2HmJMv5DSV3ERCQDHW3O2yZC35ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9WnxoB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9WnxoB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6100AC116B1;
	Thu, 25 Jul 2024 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918846;
	bh=RF9n2+mSRlFrkpFHMIEg3Z/dF+crOrSNrrqnNlfJyu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9WnxoB1Twykn1anXHPf5AOmPp7pBthMTgoVZPifxUEzL+X3qes7vEPyUnMeCVjax
	 Cd0WnOKlkU4aGzmtfGz4aKmZF1gWaN2D4FcXKo0+coW4AsEXXDYar8Ap4O5OLqRQU3
	 +JAoje9tWh7CFhXu4TckXmVzVJJsnqRAEWmvOytc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 28/29] ALSA: seq: ump: Skip useless ports for static blocks
Date: Thu, 25 Jul 2024 16:37:38 +0200
Message-ID: <20240725142732.729530544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3bfd7c0ba184de99e9f5083b29e5308f30767265 upstream.

When the UMP Endpoint is configured with static blocks, the block
configuration will never change, hence the unused ports will be
unchanged as well.  Creating sequencer ports for those unused ports
is simply useless, and it might be rather confusing for users.
The idea behind the inactive ports was for allowing connections
from/to ports that can become usable later, but this will never
happen for inactive groups in static blocks.

Let's change the sequencer UMP binding to skip those unused ports when
the UMP EP is with static blocks.

Fixes: 81fd444aa371 ("ALSA: seq: Bind UMP device")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240717083322.25892-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_ump_client.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -28,6 +28,7 @@ struct seq_ump_group {
 	int group;			/* group index (0-based) */
 	unsigned int dir_bits;		/* directions */
 	bool active;			/* activeness */
+	bool valid;			/* valid group (referred by blocks) */
 	char name[64];			/* seq port name */
 };
 
@@ -210,6 +211,13 @@ static void fill_port_info(struct snd_se
 		sprintf(port->name, "Group %d", group->group + 1);
 }
 
+/* skip non-existing group for static blocks */
+static bool skip_group(struct seq_ump_client *client, struct seq_ump_group *group)
+{
+	return !group->valid &&
+		(client->ump->info.flags & SNDRV_UMP_EP_INFO_STATIC_BLOCKS);
+}
+
 /* create a new sequencer port per UMP group */
 static int seq_ump_group_init(struct seq_ump_client *client, int group_index)
 {
@@ -217,6 +225,9 @@ static int seq_ump_group_init(struct seq
 	struct snd_seq_port_info *port __free(kfree) = NULL;
 	struct snd_seq_port_callback pcallbacks;
 
+	if (skip_group(client, group))
+		return 0;
+
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port)
 		return -ENOMEM;
@@ -250,6 +261,9 @@ static void update_port_infos(struct seq
 		return;
 
 	for (i = 0; i < SNDRV_UMP_MAX_GROUPS; i++) {
+		if (skip_group(client, &client->groups[i]))
+			continue;
+
 		old->addr.client = client->seq_client;
 		old->addr.port = i;
 		err = snd_seq_kernel_client_ctl(client->seq_client,
@@ -284,6 +298,7 @@ static void update_group_attrs(struct se
 		group->dir_bits = 0;
 		group->active = 0;
 		group->group = i;
+		group->valid = false;
 	}
 
 	list_for_each_entry(fb, &client->ump->block_list, list) {
@@ -291,6 +306,7 @@ static void update_group_attrs(struct se
 			break;
 		group = &client->groups[fb->info.first_group];
 		for (i = 0; i < fb->info.num_groups; i++, group++) {
+			group->valid = true;
 			if (fb->info.active)
 				group->active = 1;
 			switch (fb->info.direction) {


