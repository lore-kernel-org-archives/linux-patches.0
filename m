Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225D9308F0A;
	Sun,  7 Jun 2026 10:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827298; cv=none; b=Z5GjAoIm+mVGABS3+l4eEL8kZQtfJH7f1QkJAdp8fD+ujD7V66qgrjdPhWbUNT37FGTHHjfHsVNvVTzAlN+01IZg8thkZCe/mU2ILDKogj0QXQ1psECFveMVOYHJJPKYfnguKC7KX3ua6jCAhpHCgtcpM0X+NdguAItdgqudOzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827298; c=relaxed/simple;
	bh=7sXM3GnPfmyyci3f0KXt+bNUrzOJJ2eQgPyZMGNNNSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2u5x4W5wvvZh7FLj/tylovVz4o2bC7uR1sKBxWqn7BdeZJRgNHR6swZJiN98E4gd6GwkuOJDT/x6iHTChWvoCDY5/64JfdZX4OUvPPsVDq4EH2eOvILNX/Bwv4JEIdggis4PT00R6+OX/5yRucmY4tm4nzcU2K42DDh2ZHb+wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyHjQBcQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyHjQBcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669B91F00893;
	Sun,  7 Jun 2026 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827297;
	bh=PWPFsxYScVI4Mc9BnPY6ut8mzNF6R6grdA91b50hVmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyHjQBcQFDWcRsVygMJyLI1+JEx1PU4fnH4z4G3tq/kWlsELMV5qXoMB+CE1cS8qD
	 on4t2JtnSl4QPOMk7ExqkkLOlbh/JomB5LPlM9UaQDVg2ohxEoSCycOq6m4XcVqo0v
	 XHTMeUU4eVjzvEy/bAUnOBmABTNb3+XuNYnYY7Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8e498074a794999eb41c@syzkaller.appspotmail.com,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/307] ALSA: pcm: oss: Fix setup list UAF on proc write error
Date: Sun,  7 Jun 2026 11:57:20 +0200
Message-ID: <20260607095729.285703040@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 4cc54bdd54b337e77115be5b55577d1c58608eae ]

snd_pcm_oss_proc_write() links a newly allocated setup entry into the
OSS setup list before duplicating the task name. If the task-name
allocation fails, the error path frees the already linked entry and
leaves setup_list pointing at freed memory.

A later OSS device open can then walk the stale list entry in
snd_pcm_oss_look_for_setup() and dereference freed memory.

Allocate the task name and initialize the setup entry before publishing
the entry on setup_list. Also fetch the initial proc read iterator only
after taking setup_mutex, so all setup_list traversal follows the same
list lifetime rules.

Reported-by: syzbot+8e498074a794999eb41c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a1062b7.170a0220.35b2b7.0003.GAE@google.com
Closes: https://syzkaller.appspot.com/bug?extid=8e498074a794999eb41c
Fixes: 060d77b9c04a ("[ALSA] Fix / clean up PCM-OSS setup hooks")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260522-alsa-pcm-oss-setup-uaf-v1-1-40bdcc4d17e8@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/pcm_oss.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index daa7cda98ae6f6..a65a3b8d04b8cb 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2966,8 +2966,10 @@ static void snd_pcm_oss_proc_read(struct snd_info_entry *entry,
 				  struct snd_info_buffer *buffer)
 {
 	struct snd_pcm_str *pstr = entry->private_data;
-	struct snd_pcm_oss_setup *setup = pstr->oss.setup_list;
+	struct snd_pcm_oss_setup *setup;
+
 	guard(mutex)(&pstr->oss.setup_mutex);
+	setup = pstr->oss.setup_list;
 	while (setup) {
 		snd_iprintf(buffer, "%s %u %u%s%s%s%s%s%s\n",
 			    setup->task_name,
@@ -3052,6 +3054,13 @@ static void snd_pcm_oss_proc_write(struct snd_info_entry *entry,
 				buffer->error = -ENOMEM;
 				return;
 			}
+			template.task_name = kstrdup(task_name, GFP_KERNEL);
+			if (!template.task_name) {
+				kfree(setup);
+				buffer->error = -ENOMEM;
+				return;
+			}
+			*setup = template;
 			if (pstr->oss.setup_list == NULL)
 				pstr->oss.setup_list = setup;
 			else {
@@ -3059,12 +3068,7 @@ static void snd_pcm_oss_proc_write(struct snd_info_entry *entry,
 				     setup1->next; setup1 = setup1->next);
 				setup1->next = setup;
 			}
-			template.task_name = kstrdup(task_name, GFP_KERNEL);
-			if (! template.task_name) {
-				kfree(setup);
-				buffer->error = -ENOMEM;
-				return;
-			}
+			continue;
 		}
 		*setup = template;
 	}
-- 
2.53.0



