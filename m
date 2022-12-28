Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307081C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC64C433D2;
	Wed, 28 Dec 2022 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245615;
	bh=AlYS/l6ElL7QqRBU9A8AzkmpdKoqNyTen6wL+yZBCuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmkSyQ6yqsgJDqVDlITRaiX7dgnyJ2AbJiSymIDg3EtnWUiS0s2RXBgZBZbpCk/7t
	 a8Ku/kcOqMN9OqgPZTmakHDDgZ48jgIJyZ/Y8V2VLlmJpzKzXkGXWwJq+/ETedzynA
	 tDiMagznunNtBovhIjwsxt+UvBcHkPaqz8BgyVq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Liska <mliska@suse.cz>,
	Ariel Elior <aelior@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0923/1073] qed (gcc13): use u16 for fid to be big enough
Date: Wed, 28 Dec 2022 15:41:51 +0100
Message-Id: <20221228144353.097879839@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 7d84118229bf7f7290438c85caa8e49de52d50c1 ]

gcc 13 correctly reports overflow in qed_grc_dump_addr_range():
In file included from drivers/net/ethernet/qlogic/qed/qed.h:23,
                 from drivers/net/ethernet/qlogic/qed/qed_debug.c:10:
drivers/net/ethernet/qlogic/qed/qed_debug.c: In function 'qed_grc_dump_addr_range':
include/linux/qed/qed_if.h:1217:9: error: overflow in conversion from 'int' to 'u8' {aka 'unsigned char'} changes value from '(int)vf_id << 8 | 128' to '128' [-Werror=overflow]

We do:
  u8 fid;
  ...
  fid = vf_id << 8 | 128;

Since fid is 16bit (and the stored value above too), fid should be u16,
not u8. Fix that.

Cc: Martin Liska <mliska@suse.cz>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221031114354.10398-1-jirislaby@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 5250d1d1e49c..86ecb080b153 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1972,9 +1972,10 @@ static u32 qed_grc_dump_addr_range(struct qed_hwfn *p_hwfn,
 				   u8 split_id)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	u8 port_id = 0, pf_id = 0, vf_id = 0, fid = 0;
+	u8 port_id = 0, pf_id = 0, vf_id = 0;
 	bool read_using_dmae = false;
 	u32 thresh;
+	u16 fid;
 
 	if (!dump)
 		return len;
-- 
2.35.1



