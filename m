Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8101A3178;
	Thu, 17 Apr 2025 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913624; cv=none; b=H3ayl6MF1Y/nvRRrJ3BTsrOzRJXywXBvBE5KuqJB6D3reBKqvQFEhHB5A4IrYP4Ohe/xm5kEYC+16sipY3eMC0wUqfU65BCoutuyRdrV45HIFI6E0lOzmmmmi87t6LljfgkhwGu8ZWXB3Kr2/970nP1+dvngWsMCQhh4uxBeF64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913624; c=relaxed/simple;
	bh=/DjXizOf7yFSzgp4ulQNuGHxHJ7KYfbYjmammiGfrPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dttYWqC9mBdith4xRg4LUSaAoQk9H2PScduit8zyIiVGnbvptp9H4AuPYVvVXdEbDR9fxe9/gDRLLlThPzLyTnhz1bdbLLRKkpL022VHdbmzrfwAhPfiwyMV97QHPyp6y2YybemYAdm6+3K3ujQCg1CToIjRH46XkKniZWAHtek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkUZhyzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkUZhyzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFF6C4CEE4;
	Thu, 17 Apr 2025 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913624;
	bh=/DjXizOf7yFSzgp4ulQNuGHxHJ7KYfbYjmammiGfrPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkUZhyzz4G3BjU8ZO5jOJ6flnnDxp6ZhmCNL5an7OBjcAhKPbvaqMRzsLkryQLAvb
	 fRtuLyYGjz50C5YxQ6TTZVhysSTmFNhTWqxJS3cY3jbCjqUpAHruUHo+LoHyGSyPQH
	 DruWUwDhmN+2AbSaq9knpz9KPtgl+cW0gLwz8UJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 400/449] gve: handle overflow when reporting TX consumed descriptors
Date: Thu, 17 Apr 2025 19:51:28 +0200
Message-ID: <20250417175134.368670618@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Washington <joshwash@google.com>

commit 15970e1b23f5c25db88c613fddf9131de086f28e upstream.

When the tx tail is less than the head (in cases of wraparound), the TX
consumed descriptor statistic in DQ will be reported as
UINT32_MAX - head + tail, which is incorrect. Mask the difference of
head and tail according to the ring size when reporting the statistic.

Cc: stable@vger.kernel.org
Fixes: 2c9198356d56 ("gve: Add consumed counts to ethtool stats")
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250402001037.2717315-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -392,7 +392,9 @@ gve_get_ethtool_stats(struct net_device
 				 */
 				data[i++] = 0;
 				data[i++] = 0;
-				data[i++] = tx->dqo_tx.tail - tx->dqo_tx.head;
+				data[i++] =
+					(tx->dqo_tx.tail - tx->dqo_tx.head) &
+					tx->mask;
 			}
 			do {
 				start =


