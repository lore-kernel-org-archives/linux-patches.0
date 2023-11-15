Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7118A2FC52
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgrDL8ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F8FC433C8;
	Wed, 15 Nov 2023 19:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077579;
	bh=BFlGpTbMS3O4x/OZiJYLMtjEkptCaQAGnlNdkKk0zl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgrDL8ssdgN2JH52EnVaUW4x+P/B1z/XhQyoOvSHhhuwzYEdVIDgxUrbZqrqsHcEa
	 0n2k/CJgX49ezna52nZGY+b4qFujD4xXkgdkN9kP9NNqzwbD2zqm6Hyeh9siLwWNwT
	 QdhF5uK2DtoM3f67DKkukkeIHWHqnsXo2pZAf4KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 371/603] fs: dlm: Fix the size of a buffer in dlm_create_debug_file()
Date: Wed, 15 Nov 2023 14:15:16 -0500
Message-ID: <20231115191639.185193086@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b859e01054354033f480d9df41b0ebc2c7537379 ]

8 is not the maximum size of the suffix used when creating debugfs files.

Let the compiler compute the correct size, and only give a hint about the
longest possible string that is used.

When building with W=1, this fixes the following warnings:

  fs/dlm/debug_fs.c: In function ‘dlm_create_debug_file’:
  fs/dlm/debug_fs.c:1020:58: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
   1020 |         snprintf(name, DLM_LOCKSPACE_LEN + 8, "%s_waiters", ls->ls_name);
        |                                                          ^
  fs/dlm/debug_fs.c:1020:9: note: ‘snprintf’ output between 9 and 73 bytes into a destination of size 72
   1020 |         snprintf(name, DLM_LOCKSPACE_LEN + 8, "%s_waiters", ls->ls_name);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  fs/dlm/debug_fs.c:1031:50: error: ‘_queued_asts’ directive output may be truncated writing 12 bytes into a region of size between 8 and 72 [-Werror=format-truncation=]
   1031 |         snprintf(name, DLM_LOCKSPACE_LEN + 8, "%s_queued_asts", ls->ls_name);
        |                                                  ^~~~~~~~~~~~
  fs/dlm/debug_fs.c:1031:9: note: ‘snprintf’ output between 13 and 77 bytes into a destination of size 72
   1031 |         snprintf(name, DLM_LOCKSPACE_LEN + 8, "%s_queued_asts", ls->ls_name);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 541adb0d4d10b ("fs: dlm: debugfs for queued callbacks")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/debug_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 5aabcb6f0f157..fc44ab6657cab 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -973,7 +973,8 @@ void dlm_delete_debug_comms_file(void *ctx)
 
 void dlm_create_debug_file(struct dlm_ls *ls)
 {
-	char name[DLM_LOCKSPACE_LEN + 8];
+	/* Reserve enough space for the longest file name */
+	char name[DLM_LOCKSPACE_LEN + sizeof("_queued_asts")];
 
 	/* format 1 */
 
-- 
2.42.0



