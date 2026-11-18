Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050378;
	b=Fmv5nCsos10zeorxLP5HApVeIh65pL9meNpTQSS+zH93JSmj1akBu3kRu7GIBaqz2Mi5
	 I+XrIxZzZrfS7MffJoNwt9d06Ap8dF/zI/dKj+WV8nvfNJLeqtCQaHGsPCzgR1SOJc+6t
	 8UVj+Xe8KKEqNnajSdAYZmzFMKTcR81B1XRc/roZW60ylkW5ytE5uzrQEN6seBUiltiuC
	 FuQEv8XPJ3ig6DflQokWJM/QS1u97YO12ffgBMS3WG0eBhRd2yEvPdvysWNts71clENE9
	 dlBFPqdrr33Tt7c7EFd5lwYDw6ejyTK/GGXm4dPN49/50WX31Cr/3dD68YMQsb+6etA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mkDNaq7BJ6lOE01zK3AKWKyYZNFK8rD1AzEq2RnYeJQ=;
	b=Kkk03JcJjhiV60Twn9PvaL6RgUybdrMxLzCcP7QiYCK1VzTGR907CtdIJ/qi7+sw9MEI
	 RM0CrCpLgJYubyizgHETn4r9znr35PH9yKbr8FWPJ3Sdf/t+Mvs/hwxqnsfZPQJ8M58kw
	 yKIU7eH7i+mttwYcyV1MMYDtfP2eK5100aRIMheyMKhih4FksjeJb1DoKSJNTtKUc1uJK
	 8KZxFhAwpeB/z+6hVrP0K1I8dKfgenb/rBs0Elnh6cNl1FXfakYA8Xsv/kdAIcsfFPqIQ
	 CARpy8STZWYWBrZqu4O8011JVyvzEsgrxLmib0RSqJMiSS9+e27PWDpQ/PHr/AZl+jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+QPlqlD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086B2606A336;
	Thu, 19 Nov 2026 01:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+QPlqlD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477C31F000C4;
	Thu, 19 Nov 2026 01:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050377;
	bh=mkDNaq7BJ6lOE01zK3AKWKyYZNFK8rD1AzEq2RnYeJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+QPlqlDtD97fF+5qIg6P1Sed1f8+JYFpcRjdUrsFRUlMDiZU1zxGZbymStVgMe49
	 tF9SsKR2qS11G6QHiztTyA1qM19Rj2gmr2qJMLj53PEpkJqEz00crNj4b5uOQwF3h1
	 MtbYEC8I+D3slYGipqzuXNiNe4MDwwOSZVIVSrwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2686/2857] nvme-fabrics: limit each queue type to the number of online CPUs
Date: Wed, 18 Nov 2026 16:02:00 +0100
Message-ID: <20261118150338.284491150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 99fd0cbae84988e0af34784aa18ddd51ae094ade ]

nvmf_nr_io_queues limits each queue type to the number of online CPUs
when asking for I/O queues, but nvmf_set_io_queues hands out the
granted queues without these limits, and only nr_io_queues is clamped
when parsing the options.

E.g. with 2 CPUs, nr_io_queues=2, nr_write_queues=10 and
nr_poll_queues=10, 2 + 2 + 2 = 6 queues are requested, but handed out
as 4 default, 2 read and 0 poll queues.  blk_mq_map_queues can't create
more CPU masks than there are CPUs, so default queues 2 and 3 take over
the CPUs of default queues 0 and 1, and connecting the I/O queue of
default queue 1 fails with -EXDEV.

Apply the same limits in nvmf_set_io_queues.  A queue type with more
queues than online CPUs always has a hardware context without an online
CPU, so no working setup changes.  The options are not modified, so the
limits follow CPU hotplug on reconnect.

Fixes: 6486199378a5 ("nvme-tcp: fix queue mapping when queue count is limited")
Fixes: a249d3066de6 ("nvme-fabrics: add queue setup helpers")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index f7dc799b1dbd3..32d0dbd6ae464 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -962,18 +962,27 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
 			u32 io_queues[HCTX_MAX_TYPES])
 {
+	/*
+	 * Each queue type is mapped to the CPUs separately, so a type with
+	 * more queues than online CPUs has hardware contexts without an online
+	 * CPU.  Use the same limits as nvmf_nr_io_queues.
+	 */
+	u32 nr_io = min(opts->nr_io_queues, num_online_cpus());
+	u32 nr_write = min(opts->nr_write_queues, num_online_cpus());
+	u32 nr_poll = min(opts->nr_poll_queues, num_online_cpus());
+
 	memset(io_queues, 0, sizeof(*io_queues) * HCTX_MAX_TYPES);
 
-	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
+	if (nr_write && nr_io < nr_io_queues) {
 		/*
 		 * separate read/write queues
 		 * hand out dedicated default queues only after we have
 		 * sufficient read queues.
 		 */
-		io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
+		io_queues[HCTX_TYPE_READ] = nr_io;
 		nr_io_queues -= io_queues[HCTX_TYPE_READ];
 		io_queues[HCTX_TYPE_DEFAULT] =
-			min(opts->nr_write_queues, nr_io_queues);
+			min(nr_write, nr_io_queues);
 		nr_io_queues -= io_queues[HCTX_TYPE_DEFAULT];
 	} else {
 		/*
@@ -982,14 +991,14 @@ void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
 		 * sufficient queue count to have dedicated default queues.
 		 */
 		io_queues[HCTX_TYPE_DEFAULT] =
-			min(opts->nr_io_queues, nr_io_queues);
+			min(nr_io, nr_io_queues);
 		nr_io_queues -= io_queues[HCTX_TYPE_DEFAULT];
 	}
 
-	if (opts->nr_poll_queues && nr_io_queues) {
+	if (nr_poll && nr_io_queues) {
 		/* map dedicated poll queues only if we have queues left */
 		io_queues[HCTX_TYPE_POLL] =
-			min(opts->nr_poll_queues, nr_io_queues);
+			min(nr_poll, nr_io_queues);
 	}
 }
 EXPORT_SYMBOL_GPL(nvmf_set_io_queues);
-- 
2.53.0



