Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7460018B00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlFlBXTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF248C433C7;
	Mon,  9 Oct 2023 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856919;
	bh=ZE6AxiR2xm5MfJdzgwoysHo7uXBPpgVPx7MPz3tE0TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlFlBXTPNst5LAs/p4ZP90zUsY90gnKSQ4pb0Ux8N94ErHdIW2XzCySeBAMuZNS1i
	 lyg1PWqNrozO9yXqCvRPLen/xaxHOA+VBedbcXqB5R/BkVY6DEzC94YWupU/Sj3My3
	 Ew0RZt3i4jVeh+hmf45FyqazsDjCBv243te5PbvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 008/163] maple_tree: add mas_is_active() to detect in-tree walks
Date: Mon,  9 Oct 2023 14:59:32 +0200
Message-ID: <20231009130124.250840174@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <Liam.Howlett@oracle.com>

[ Upstream commit 5c590804b6b0ff933ed4e5cee5d76de3a5048d9f ]

Patch series "maple_tree: Fix mas_prev() state regression".

Pedro Falcato retported an mprotect regression [1] which was bisected back
to the iterator changes for maple tree.  Root cause analysis showed the
mas_prev() running off the end of the VMA space (previous from 0) followed
by mas_find(), would skip the first value.

This patchset introduces maple state underflow/overflow so the sequence of
calls on the maple state will return what the user expects.

Users who encounter this bug may see mprotect(), userfaultfd_register(),
and mlock() fail on VMAs mapped with address 0.

This patch (of 2):

Instead of constantly checking each possibility of the maple state,
create a fast path that will skip over checking unlikely states.

Link: https://lkml.kernel.org/r/20230921181236.509072-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230921181236.509072-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/maple_tree.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 295548cca8b36..e1e5f38384b20 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -503,6 +503,15 @@ static inline bool mas_is_paused(const struct ma_state *mas)
 	return mas->node == MAS_PAUSE;
 }
 
+/* Check if the mas is pointing to a node or not */
+static inline bool mas_is_active(struct ma_state *mas)
+{
+	if ((unsigned long)mas->node >= MAPLE_RESERVED_RANGE)
+		return true;
+
+	return false;
+}
+
 /**
  * mas_reset() - Reset a Maple Tree operation state.
  * @mas: Maple Tree operation state.
-- 
2.40.1



