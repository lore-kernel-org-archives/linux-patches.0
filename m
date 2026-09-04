Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D23411A1C;
	Fri,  4 Sep 2026 05:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501397; cv=none; b=OiNnzdoSLEQ6ob9tWztdkZSHnNsr5KTA3CNL+UVEOeTI9Fdhw1LAWheVusNO4bnKpFVF0e0DQCRPMljk6v8hi1nCRcB1owhBLmJDz7pRGRmDuEYBiSfNgPFp4PsLxuhsKNuEwI5N67+b9v4UqMlOhhvlv0btqGm21Fcd89+hpVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501397; c=relaxed/simple;
	bh=St/ayOL0zc9KtzQcMzEHth745Uu6ba0T+18yonprfYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgnTERhl1DzUaMrfNNnxIUYqVhH3Galp5oUWzVDyGMwa9FHfjz5c0alt/J3+DzsQX4Cy2O1FIlCYU3fvYzDB+qCfqnCZLXgVFUbKynq34zbpxUSPlfD4EGNMj1dnXMcOqM74Hb355pV4lVKmWq2ufSP5y4CMuFWCi4KoOXp9Eks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOp+nFi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOp+nFi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5847B1F00A3F;
	Fri,  4 Sep 2026 05:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501395;
	bh=CV3EL8ZjP5HBVtcecuW8pg6HjWHGNjouTkm35lYg2R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOp+nFi6its9bWcxXukYjHoJCuVNeRJoGAIJ+yEdxNpkrpgJlkz3ObCRrmQkEtgSf
	 4kGDt7RpBZ5r9WqNstzR20DUJeRyVSgOSvCqaC+x+zSm2b7NdRFUClt902zOhDIbeg
	 bSHUldaW2OyvPmCAP21cRGYPFnFh+8LzgtlNX0qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 352/552] ipmi: Fix use-after-free of cmd_rcvr in _ipmi_destroy_user()
Date: Fri,  4 Sep 2026 06:58:29 +0200
Message-ID: <20260904045758.225517130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Yifei Gao <gyf161023@gmail.com>

commit 05ec76cfbce653e07cec19b9b8b20e33449d5d87 upstream.

Commit 9e91f8a6c868 ("ipmi:msghandler: Remove srcu for the
ipmi_interfaces list") dropped the synchronize_rcu() between unlinking
the command receivers from intf->cmd_rcvrs and freeing them, updating
only the comment that explains why the barrier is needed.

The cmd_rcvrs list is still traversed under plain RCU: find_cmd_rcvr()
walks it inside rcu_read_lock(), and handle_ipmb_get_msg_cmd() borrows
rcvr->user from that lookup within the same read-side section. Without
the grace period, _ipmi_destroy_user() can kfree() a cmd_rcvr while a
reader still holds a pointer to it, causing a use-after-free.

The rework only made srcu unnecessary for the interfaces list; the
cmd_rcvrs list still relies on plain RCU. Restore the synchronize_rcu()
before freeing the receivers.

Fixes: 9e91f8a6c868 ("ipmi:msghandler: Remove srcu for the ipmi_interfaces list")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Message-ID: <20260825234630.1196170-1-gyf161023@gmail.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1393,6 +1393,7 @@ static void _ipmi_destroy_user(struct ip
 		}
 	}
 	mutex_unlock(&intf->cmd_rcvrs_mutex);
+	synchronize_rcu();
 	while (rcvrs) {
 		rcvr = rcvrs;
 		rcvrs = rcvr->next;


