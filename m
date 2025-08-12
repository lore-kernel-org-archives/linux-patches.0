Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4531EF38C;
	Tue, 12 Aug 2025 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023235; cv=none; b=akL4aYHFcF4dQbLtvkvU0VVrcRhztvla2P0ZQICkUcw2MM+q+ePoRVqi/x3SRbpAQEM/iQHLNuC2w2pp0lsJ/zvEr2aUq/2i7oB6cshE+x5dqILu7RqsI+fioGYWKBMC0sqGdP9oetI708yp5dU4KEYYEGDmysvaLmYeayIVHzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023235; c=relaxed/simple;
	bh=Be/bPe5Z5gORVTNAQvgACKZc278ZzujneRgdFCkzyhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qz2/Ujl7YAnyWa9k3DEEXdID0Q8EKVqyiOiJO4jWdrEQXr8o2g6aU0tqVKOcfv4Z2Wrb5lJlZ3eP0zzPZXGR/ncXTeZ1Emp6abx505vd/gLDoVhL1G2cmCW6luiMlWmDKqe9Ud+zKtQERGdmGH2rMMO84QQ5s/FWK9tmBge5XZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LURhCB0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LURhCB0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DE1C4CEF0;
	Tue, 12 Aug 2025 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023235;
	bh=Be/bPe5Z5gORVTNAQvgACKZc278ZzujneRgdFCkzyhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LURhCB0ApHL2huBKvgAuRQVNUNAItXD7u2uawXSH2YBSm9/J1N5jW3lEXEK+eImRD
	 FgkxBZ2vr6l7yz9StvjCofzEVjFCg2WIKEXz6v3s02iXAuq26ACCskGkdp7DyUCi6t
	 MdnIJ6bqSLTF0Irgd4zyIpF8qTYfPut7olNFQIew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Yu Kuai <yukuai@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 020/627] md/raid10: fix set but not used variable in sync_request_write()
Date: Tue, 12 Aug 2025 19:25:15 +0200
Message-ID: <20250812173420.088762011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit bc1c2f0ae355f7e30b5baecdfb89d2b148aa0515 ]

Building with W=1 reports the following:

drivers/md/raid10.c: In function ‘sync_request_write’:
drivers/md/raid10.c:2441:21: error: variable ‘d’ set but not used [-Werror=unused-but-set-variable]
 2441 |                 int d;
      |                     ^
cc1: all warnings being treated as errors

Remove the usage of that variable.

Fixes: 752d0464b78a ("md: clean up accounting for issued sync IO")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/linux-raid/20250709104814.2307276-1-john.g.garry@oracle.com
Signed-off-by: Yu Kuai <yukuai@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c9bd2005bfd0..d2b237652d7e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2446,15 +2446,12 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 * that are active
 	 */
 	for (i = 0; i < conf->copies; i++) {
-		int d;
-
 		tbio = r10_bio->devs[i].repl_bio;
 		if (!tbio || !tbio->bi_end_io)
 			continue;
 		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
 		    && r10_bio->devs[i].bio != fbio)
 			bio_copy_data(tbio, fbio);
-		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
 		submit_bio_noacct(tbio);
 	}
-- 
2.39.5



