Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062982;
	b=eQF/dgMLYw7jbPl0VPrxc7ts45exAU8hfMOVUXtSxVoxfE5dMwfMLZ5fcsrdXN/y8r3R
	 63otuZQNIsyv2i7nUrQRlD2v6pIaHTONtVbgMyZGEMITDr0c628H/uetQA89LPcCSEuat
	 KBd73bZRw+7cy37pIy+JhI1dLawECRzFjq70+A+Etgylvs73I9gEjXKTjgWPy79tL0Bkh
	 1/15g/2bWZzo4qUM66jZ1rIPmaoXzoopuDW06/qbzZxsl9++NoDtalp1GRrM8YiGvXk0v
	 OadWxwLGw9hmycESc06yYhiBo5BnAHjdCgwaly7rKd6faJxW7MmmDJdNTO6BT6nvIIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MS1Zvgb7YJNCKgI7hAKyrMRSBXGZbCdCh5Hw2VQSquo=;
	b=dVPp1sdydUowF/HPffwwHD70SAgIdUEYUo0yFvndI9NYnZb9eWoQglGqg4VUzgS8PtP1
	 uSELHZq2P50knM6z+ZlsC+Ns/D4pfi0t5oKXurIql7y1ag49yDqPNiJsfqhvQTShXkKzS
	 xRFvodlTj8j9wniU7flY5sTFbr7pPjHTYK+YWaGlDFIKADfreqLya5iFJjVPofNJZ6W8f
	 VNVJi3RelYVyer4ELR9Uhc81wCAGx25d/+gs1K9wMOZePSktufOjpbGrSBDt8nuhYCKm5
	 Pcr7tuh4r/Ik+4B007AldKnaH1hj9ZQpOdH7NLdrIINFItLbGZ/TsTYM23uUsMbW/nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIUepbGi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3009D606A33B;
	Sat,  7 Nov 2026 14:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIUepbGi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA951F0089F;
	Sat,  7 Nov 2026 14:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062982;
	bh=MS1Zvgb7YJNCKgI7hAKyrMRSBXGZbCdCh5Hw2VQSquo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIUepbGi8Q7zt20G8META8keFD4ZKVEDw8Lb0+Dwh7xhPmdDa16QwukXEqX+UDIet
	 caa6lVAwL6Blo0R7Dzd4nfy69fSCeyq8SNOVbWT0JrwitYk4MEcDHMZNnHOyDuPL3Y
	 a8btTmFHUI+yoy2NSWLv83oI4Z1KxiHqBzelE7MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 242/869] platform/x86/intel/pmt: Block mmap when callback is present
Date: Sat,  7 Nov 2026 08:48:44 -0500
Message-ID: <20261107134900.020474635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

[ Upstream commit 0d4cd92b41dd33a3112959f9be86002ff309de73 ]

With the introduction of the .read_telem() callback, control
for access to a devices data area must be done by the callback
owner.

This means that an area cannot be mmap-ed with the default PMT
handler.

If the .read_telem() callback is present, do not support mmap.

Fixes: 045a513040cc ("platform/x86/intel/pmt: Use PMT callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20260910135954.1586360-2-michael.j.ruhl@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/class.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index 8077274726b5d..9ec843617e3c9 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -339,7 +339,14 @@ static int intel_pmt_dev_register(struct intel_pmt_entry *entry,
 	sysfs_bin_attr_init(&entry->pmt_bin_attr);
 	entry->pmt_bin_attr.attr.name = ns->name;
 	entry->pmt_bin_attr.attr.mode = 0440;
-	entry->pmt_bin_attr.mmap = intel_pmt_mmap;
+
+	/*
+	 * The read_telem callback controls access to the memory area. Block
+	 * usage if the read_telem callback is present.
+	 */
+	if (!(entry->cb && entry->cb->read_telem))
+		entry->pmt_bin_attr.mmap = intel_pmt_mmap;
+
 	entry->pmt_bin_attr.read = intel_pmt_read;
 	entry->pmt_bin_attr.size = entry->size;
 
-- 
2.53.0



