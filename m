Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9421D145;
	Mon, 18 Dec 2023 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4Wi2jIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0211FC433C7;
	Mon, 18 Dec 2023 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908599;
	bh=n3LKda7BGUDAAe8ZgS9mGgnNTIvuUS6bbIExC4tmX0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4Wi2jIxohCxHys667/p/6pnTlm76JG9GJzkcTKuN4ajh7l7hd7BRa5iXicwAtYgk
	 gEfxMK5IZoMwx33G8/Cx3/lXGgcY7VvaOKBNB+7TEZ4IZVKx1W7wI1+eeuMdbNW4Yz
	 /stnmOHaiIZv/ZljWO7jriEoFWFaY6CdTzxgpVDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 51/62] team: Fix use-after-free when an option instance allocation fails
Date: Mon, 18 Dec 2023 14:52:15 +0100
Message-ID: <20231218135048.506707578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -284,8 +284,10 @@ static int __team_options_register(struc
 	return 0;
 
 inst_rollback:
-	for (i--; i >= 0; i--)
+	for (i--; i >= 0; i--) {
 		__team_option_inst_del_option(team, dst_opts[i]);
+		list_del(&dst_opts[i]->list);
+	}
 
 	i = option_count;
 alloc_rollback:


