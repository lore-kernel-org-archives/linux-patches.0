Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036422;
	b=jDuzB2r37W0SWFau6rw6EEVRWFRW+IuuQHHeZacIIlkpxGou9/9DoCmOdbZteeO2AE3B
	 p39t9wq0235feXvz9WkS0MxTzBjUW50ccLdlRdi2wihRmF9USXJMq2B5a9AZZ32YnUZMp
	 pt1sNHK7U8AsaxIJyiveCtSWSGyS9/eIUGfFvRkpoo04ht5QDpOrBN1lM1I2neIWVVebl
	 qCJg9+g9hdVxinzKk9Vim1KIAtqznACY5z8vNAOElA2GTjwWOEt7fjQo6zy2BNYbZfMDC
	 0Epg2KPdSSYImW1F7aQBdphaQsG30jhKPTAHkdNTZAKlL+RtG+g0ROhFwfO8OPfXEFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=clhKa/38kZJb5APVblseG16BSGpaHgZjisg30Z45qK8=;
	b=VYU9lGBIX/5ZKRY4AUCrSU7z3JZDMlDOJJ7ZmUt8fUJdUGSMGdfX+ikyQoeJPiioBdrD
	 sUwuVXNrUNH/LciKJK8neSlW3xiOeIiPiFcJHW782IkKA1Q3Ew4LMv9MhFtyPt1vl4Nwc
	 eBLClueJTt8uxWSfLZQQsa2Z3VLGmVqtVm/ZZVxGdODtgcFfi3qE6m7jFE11OsR6zrlrj
	 uZ2CadXfwbAB1gy/4qZNtOlLjkE4j4v/6gYxtiqm6y9oV1kW03J0IFP3cYor265r4wep+
	 4UyAvji2crsvtd6eDKMQWwNVBiiExH5V5gbkyQ9jV/IHxpDzUjwy4yINYGN+vz1tsYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ukC/W1jE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C360A2604;
	Wed, 18 Nov 2026 21:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukC/W1jE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CB31F000C7;
	Wed, 18 Nov 2026 21:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036422;
	bh=clhKa/38kZJb5APVblseG16BSGpaHgZjisg30Z45qK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukC/W1jEk7K+a/Ek7rGUK2YjKKn+/W4JQvzCiR7mR0lsA+y9m4aD0/WC6cvkuAJl5
	 e6ZDKZVtvJsGCDmEtpCUKpBVV9p1AobM3bNZ0lw2yAj6S54QIV9yvWdXhHuLo3UfBY
	 A8LPe9qA/K+FqLPjN4ofAaNWRrdbK1H6Saz4OvUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1017/3318] PCI/AER: Fix memory leak in aer_recover_queue() on kfifo buffer overflow
Date: Wed, 18 Nov 2026 15:27:19 +0100
Message-ID: <20261118150350.393615913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priyank Rathod <rathodpriyank@google.com>

[ Upstream commit 07938f8a3cbf3e9cc27553b8982e2d56c15b354a ]

When ACPI APEI/GHES processes PCIe AER error records, it allocates memory
for aer_capability_regs (aer_regs) from ghes_estatus_pool and passes it to
aer_recover_queue() to be enqueued into aer_recover_ring.

If kfifo_in_spinlocked() fails due to a buffer overflow,
aer_recover_queue() logged an error message but returned without freeing
aer_regs. Because the entry was rejected and never inserted into the queue,
aer_recover_work_func() could never dequeue or free it, leaking the
allocated ghes_estatus_pool memory.

aer_recover_queue() returns void, so the caller ghes_handle_aer() cannot
free the buffer itself: ownership is transferred to the AER code, which
until now only released it on the success path.

Free aer_regs via ghes_estatus_pool_region_free() when
kfifo_in_spinlocked() fails on buffer overflow.

Fixes: e2abc47a5a1a ("ACPI: APEI: Fix AER info corruption when error status data has multiple sections")
Signed-off-by: Priyank Rathod <rathodpriyank@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928-b4-fix-aer-memleaks-v5-1-ba6b94c9c9a6@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 628ca8a597061..bdf7e32529f99 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1051,11 +1051,14 @@ void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
 	};
 
 	if (kfifo_in_spinlocked(&aer_recover_ring, &entry, 1,
-				 &aer_recover_ring_lock))
+				 &aer_recover_ring_lock)) {
 		schedule_work(&aer_recover_work);
-	else
+	} else {
 		pr_err("buffer overflow in recovery for %04x:%02x:%02x.%x\n",
 		       domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
+		ghes_estatus_pool_region_free((unsigned long)aer_regs,
+					      sizeof(struct aer_capability_regs));
+	}
 }
 EXPORT_SYMBOL_GPL(aer_recover_queue);
 #endif
-- 
2.53.0



