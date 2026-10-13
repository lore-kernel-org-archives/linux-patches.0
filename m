Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FAC4E4C5A;
	Tue, 13 Oct 2026 11:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892174; cv=none; b=XYkBM9mTRg0x7jx1N8DEsEy4d2wNI3zbHi3pqS7nfQSWlqroEpIsXUl/qhV6vGvqSy0ekCRA3kTk5mjJfr5dCo0lNoHy9+D5dcuPuL5yvIk7AXK5zGlAevGhzkiNAs1ccaJe0+5aVelCQEUla9ImWgTs4t7YkwxILSiSubeomr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892174; c=relaxed/simple;
	bh=+tXBhPEVrEaxafocQOsT7SVCjXtOEiFsFO+5be6VRpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NF58MbKfsiDGYEg9vDRh0XnLHGsQjs1AUZTWgCIwuILZdTB23eYhqc1rDIVMmusmjhYSLAug8c8WJm1kp43XVRqvU4xstLxoY35T0Oc6y172GrtAkPF+J0ihnb3kN7+fbFf4nut+Q78A1D3/m11RsTRPNqTL4dhHE7TnFrGEjiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0L0Npvt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0L0Npvt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0251F000FF;
	Tue, 13 Oct 2026 11:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892173;
	bh=yHr4GNYAmyehqPgYGmkon3VFV5nO2jNfWqjwKOWEPts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0L0Npvt66xRGL0wcp0rYOv4N6XuKb4SC3iGLY9/rIUvDHRH/YpqPq/NHhWabkiEIt
	 a//OuD9JMN4aGJTXb9tVZO56hNsoVJtW/MTP9/QW/90htG5oWt4Ff+ajm0+Nm7beic
	 sRE977xJiW5JfZ8AReIgzYGsAEsHy+YH6zRvaQx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 086/281] net: sparx5: free the matchall entry on destroy
Date: Tue, 13 Oct 2026 13:36:42 +0200
Message-ID: <20261013112857.219673628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

commit 2b82e16d6084cbc651e3c902198f1945408ee1a5 upstream.

sparx5_tc_matchall_replace() allocates a struct sparx5_mall_entry for
every offloaded matchall filter and adds it to sparx5->mall_entries.
sparx5_tc_matchall_destroy() removes the entry from the list, but never
frees it, so the entry of every deleted mirror and goto matchall filter
is leaked.

Free the entry after unlinking it.

The leak was discovered by an AI code review agent, and reproduced with
kmemleak on a lan969x EV board (EV23X71A) by repeatedly adding and
deleting matchall mirror and goto filters. With the fix, kmemleak no
longer reports the leak.

Cc: stable@vger.kernel.org
Fixes: 1ede4acf045c ("net: sparx5: add bookkeeping code for matchall rules")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261007-sparx5-matchall-kfree-net-v1-1-c8918685b337@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
@@ -160,6 +160,7 @@ static int sparx5_tc_matchall_destroy(st
 	}
 
 	list_del(&entry->list);
+	kfree(entry);
 
 	return err;
 }


