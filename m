Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590461;
	b=FavkF62oCsho3XA9hFw1DiFs1sfh6qE1OeykYjRED1RZqxf+Cch4uWhFCahaoS3QfrUO
	 0R0CQFbIoMBzcZ/5hPVFt3Mgcw8be21xHZYwGufdgR8J/RrruIoq7YMpQGa6MXnbwS9yH
	 Ood2OAKDl1yaTPbUC7CdzPjHyud6/71lMSshiRRuTt//4/AvhDvbRewJ/CCK35ed0563F
	 UiYHp2q3ZjhF+xeX4sYK8YQx8S+XpfRdXccz4NuZhvmaDfqBUDgY48dkJ8nJacNAIbueQ
	 hSGeef3s+atw2pr4/4Z+XXCDUSUAtlgSqdwPbWREx4Mf+dncDG+UAgdLuduGHU9R6wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e8eWOAj6MRcA3BcoHPQ2ir/wBKyFy/lRhy8xb0q2l7c=;
	b=MP2vmQG1I0tAeztlz06scRKkHWJVKUp1TLROxoV+HRe0UWb672QNxJQM2xKh2UBxLpB3
	 QTMz64HZTgaJ55PUDT87VrjQq65XdZ2XWT6Tb3eDpqedd9BUQPqZ5ZmTpCEHDLjn/mn0Q
	 lqLKGLtGUjkd9FfzBoZpjN8n2pE0pjKP9KJoteMfQkTzRMGhlquFr7t504V1U91gg2wXH
	 w2Oec7owvhIHjvgVQMKHSIxKFety5TEKDQ6WjF5ubOJQuqyf2pgkye82Ejg+LO0cUijTc
	 FkMEnqCO/1k9Qal0loQYQgUT4cY6lWUhH0puCLeSa5VNC2sO6j9LawzA4MfqmzYMQgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M21VJlWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4292A6071431;
	Fri, 13 Nov 2026 17:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M21VJlWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33091F000C4;
	Fri, 13 Nov 2026 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590461;
	bh=e8eWOAj6MRcA3BcoHPQ2ir/wBKyFy/lRhy8xb0q2l7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M21VJlWkNdiAP7dp+vAM2aiGH5xmqQAaxnAbMcYWDt8frgJHLBMuXUcV6gLEWqj6Z
	 /9lTCsT11bJxIJbhAvk/VaVC9Y8uEFMDT87Hhw/Ocb+LYYFjkv/+dyMA7DeY0dIzL2
	 E/QxE11vGq9movMZ90/lE1lhclDojLYP2apjEsHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 418/686] nvmet: dont return memory contents beyond valid data when reading ANA log page
Date: Fri, 13 Nov 2026 10:49:11 -0500
Message-ID: <20261113153835.125573338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit 29b8758b4700357909f06705a0c48c7a60c556d5 ]

The host side does not know how much valid data will be returned by the target
so it will typically provide a buffer larger than the amount of valid data in
the ANA log page.  The memory allocation used by the target does not guarantee
that prior kernel memory contents will not be returned past the end of the valid
page data.  Fix this to ensure that the SGL is zeroed before copying the data.

Fixes: 72efd25dcf4f ("nvmet: add minimal ANA support")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index f86336c79056d..007029eaca39b 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -543,6 +543,15 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 	u16 ngrps = 0;
 	u16 status;
 
+	/*
+	 * The header and one descriptor per enabled group are the only bytes
+	 * written below; zero the whole transfer first so the unwritten tail
+	 * does not leak stale kernel memory to the host.
+	 */
+	status = nvmet_zero_sgl(req, 0, req->transfer_len);
+	if (status)
+		goto out;
+
 	status = NVME_SC_INTERNAL;
 	desc = kmalloc(struct_size(desc, nsids, NVMET_MAX_NAMESPACES),
 		       GFP_KERNEL);
-- 
2.53.0



