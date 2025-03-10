Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D783122D7A6;
	Mon, 10 Mar 2025 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629166; cv=none; b=Q56uEtP5Bn/ZSBdzaZfwVWUgkoOBA1QVC36G9KHTpjDq9XsptN8taKcyFzjdvZPaO1IrUpm6gCLMKwE4fjxuxLdCdSqbU5tvuJjCusnqCXGj0s45dQQOqoNthhrcynXxJaGl5AoRQvXmE7qg0ukDRx0kwEfnJ3tEipIJZBOZFKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629166; c=relaxed/simple;
	bh=A7RpCloDsAkdiNT49SdRt9cuH1uqOm/eocydfEaFz78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAUW8atm8BjDl2hICFtl15y5qkpIrvuhuolKkFgB6NhDYKso2/3CP7s16hjasYFaqh3k38fczI1uUsXUBlPWDyMJjwPCFo+L6KOlm1BRmlIso9T6AE+UlZATPwwmr8JQeS5o6teFkt1I+1OmtGl11kITtOil2TVECNP0Sox0Soc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E35tbzLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E35tbzLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC27C4CEE5;
	Mon, 10 Mar 2025 17:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629166;
	bh=A7RpCloDsAkdiNT49SdRt9cuH1uqOm/eocydfEaFz78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E35tbzLeGb1U98EO0XNa8hiULO8R+elZ/xB1KdG2kEI+tbubuDcuO6MSMlvknHIUL
	 hSop5JS9S8MGWnc+sjOHvNL4IV4IMylT1pbO32guqSo3gX2Lvjyi//pc/JuWqrooHo
	 MMIw/cSBfNrXc86o2zkpYz60Sfw7urADmhjgOV6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Anton Mitterer <calestyo@scientia.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 200/620] btrfs: output the reason for open_ctree() failure
Date: Mon, 10 Mar 2025 18:00:46 +0100
Message-ID: <20250310170553.520114966@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit d0f038104fa37380e2a725e669508e43d0c503e9 upstream.

There is a recent ML report that mounting a large fs backed by hardware
RAID56 controller (with one device missing) took too much time, and
systemd seems to kill the mount attempt.

In that case, the only error message is:

  BTRFS error (device sdj): open_ctree failed

There is no reason on why the failure happened, making it very hard to
understand the reason.

At least output the error number (in the particular case it should be
-EINTR) to provide some clue.

Link: https://lore.kernel.org/linux-btrfs/9b9c4d2810abcca2f9f76e32220ed9a90febb235.camel@scientia.org/
Reported-by: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: stable@vger.kernel.org
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1386,7 +1386,7 @@ static int btrfs_fill_super(struct super
 
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
-		btrfs_err(fs_info, "open_ctree failed");
+		btrfs_err(fs_info, "open_ctree failed: %d", err);
 		return err;
 	}
 


