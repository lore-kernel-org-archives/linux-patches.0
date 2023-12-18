Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7487F129EFE;
	Mon, 18 Dec 2023 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRthHLEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D89C433C7;
	Mon, 18 Dec 2023 13:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907539;
	bh=qBsJG1x6nXis7EZX+xrPra7qYfciIiE0GOU+U8nQ5vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRthHLEWzN35n0UqFgsaVwvj5hb7nSN9DxN6NZGXFZalHgHMB893waS6qh9SkrAJH
	 /YGj5zAj3k/x+Vijy2H/isGBpU8nlV1ZCUo8uGrqj72R6vueqaXU02zzm5bH1G+1zM
	 Bn6QWuVwms0RM/SL//QPTibcl60+3UZh6C9sTDXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 23/26] team: Fix use-after-free when an option instance allocation fails
Date: Mon, 18 Dec 2023 14:51:25 +0100
Message-ID: <20231218135041.526707882@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135040.665690087@linuxfoundation.org>
References: <20231218135040.665690087@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florent Revest <revest@chromium.org>

commit c12296bbecc488623b7d1932080e394d08f3226b upstream.

In __team_options_register, team_options are allocated and appended to
the team's option_list.
If one option instance allocation fails, the "inst_rollback" cleanup
path frees the previously allocated options but doesn't remove them from
the team's option_list.
This leaves dangling pointers that can be dereferenced later by other
parts of the team driver that iterate over options.

This patch fixes the cleanup path to remove the dangling pointers from
the list.

As far as I can tell, this uaf doesn't have much security implications
since it would be fairly hard to exploit (an attacker would need to make
the allocation of that specific small object fail) but it's still nice
to fix.

Cc: stable@vger.kernel.org
Fixes: 80f7c6683fe0 ("team: add support for per-port options")
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20231206123719.1963153-1-revest@chromium.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -296,8 +296,10 @@ static int __team_options_register(struc
 	return 0;
 
 inst_rollback:
-	for (i--; i >= 0; i--)
+	for (i--; i >= 0; i--) {
 		__team_option_inst_del_option(team, dst_opts[i]);
+		list_del(&dst_opts[i]->list);
+	}
 
 	i = option_count;
 alloc_rollback:


