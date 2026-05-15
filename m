Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A59305686;
	Fri, 15 May 2026 16:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861348; cv=none; b=SWYtz5MGxqL6d5HZswpeZULuvLfJNvxe9CkpeiVq81Qo4hkG1WoHm99gF3mt/mrXQqzuK26FYu6ogTkb5oVDCnMPZVY90qW8ZbGWUboyiWVdIGQ7zOTdZqvd+BW1jf2zAPUiuEqWbD3cpn/Bt/JbJQOJm23aaCfGPM0tOLhGoC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861348; c=relaxed/simple;
	bh=HBydVMRtyiQcqUCo4lBChmEmqx6CpYn24R+qHCpSoMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgP4g1Ed9ohBgT1jCVRt+GSzQbWN4llLq3oEQLU2rZdBoBlc1JW4RHACb+wWaPbIS2T/2Ub2rLx1lugho3UHMBZxSRufjQXSN5YWl4/61Z/E2IVnhiwCfg90Xwc3JEqfitUW0XxC4ymOXeX6AGARafFiqLbEzjVBTX0KjCVqEy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXIuVzIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXIuVzIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEB3C2BCB0;
	Fri, 15 May 2026 16:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861348;
	bh=HBydVMRtyiQcqUCo4lBChmEmqx6CpYn24R+qHCpSoMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXIuVzIoxYmtPqCVSjJKnawaLYHyDL/5GbR56sZtFkbuAC9hKziXvio8RT0UTv3is
	 B5hp+W6FJvAK+aeXM8RB1ZZQGMCBmHDUSo3tvYclN02YaOOGxwHNuIuU20TYs20Dtx
	 OINUDee5UW08f+gehl+cvqB8uUwmw5ZhjimMCWMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 6.6 252/474] dm: dont report warning when doing deferred remove
Date: Fri, 15 May 2026 17:46:01 +0200
Message-ID: <20260515154720.451276294@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit b7cce3e2cca9cd78418f3c3784474b778e7996fe upstream.

If dm_hash_remove_all was called from dm_deferred_remove, it would write
a warning "remove_all left %d open device(s)" if there are some other
devices active.

The warning is bogus, so let's disable it in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 2c140a246dc0 ("dm: allow remove to be deferred")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -384,7 +384,7 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped)
+	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 


