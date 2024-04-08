Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297A57EF0E;
	Mon,  8 Apr 2024 13:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581958; cv=none; b=KoCOVrcvpGIP6cUVofITT6Fcv+nR0eZqtzERJ2Ecy0bcz5ynK0xxIolavOGLYiul04i2Ni5S4gGwzMaf+YzUeFhK72UUsO6XmolQe3+KnGZi25l7ftl1aDZXJRjohHvLzHW3ZlYncDKVQziOwCmuHiwd8oTbCaLaBnP/Vnfoi1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581958; c=relaxed/simple;
	bh=Ggn6hs5hT7+Ctl2op6vuG+lzesDmplDpRLB7iMhoBRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSEFOSl7UrtQAKhRfjdJdXEEQMYrVrXd/dOxtvThzxJaHkImW2xjOa8X/9qvwxSjdE4aqGUySWnikscxRZZDU9AEr7Kv6255thAk4mGd+o08q3Vw0eVgupwCeHgwNU4wW6XnuzTYnxQ06GNd1DvBaj0oWWuPcrTYabT5Pt9FrxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfB/8+a6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfB/8+a6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E4FC433C7;
	Mon,  8 Apr 2024 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581958;
	bh=Ggn6hs5hT7+Ctl2op6vuG+lzesDmplDpRLB7iMhoBRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfB/8+a6Uass4AJNMIv3N9BFHv4NaWj/uMuVb1019gKuQX8RzSQTjt8ofu3HCjs4b
	 Fs5tlUCSn5xfTKMEJK/YV2MghSklaQ1KnAzVv+XoiUjF5Tf4kbZvA+1RhA7XvGOpja
	 kuZyob79JzV4HOTdHwy2Y7ku/Y8hupV2h2IkVw78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 067/138] i40e: fix i40e_count_filters() to count only active/new filters
Date: Mon,  8 Apr 2024 14:58:01 +0200
Message-ID: <20240408125258.304373131@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

commit eb58c598ce45b7e787568fe27016260417c3d807 upstream.

The bug usually affects untrusted VFs, because they are limited to 18 MACs,
it affects them badly, not letting to create MAC all filters.
Not stable to reproduce, it happens when VF user creates MAC filters
when other MACVLAN operations are happened in parallel.
But consequence is that VF can't receive desired traffic.

Fix counter to be bumped only for new or active filters.

Fixes: 621650cabee5 ("i40e: Refactoring VF MAC filters counting to make more reliable")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1249,8 +1249,11 @@ int i40e_count_filters(struct i40e_vsi *
 	int bkt;
 	int cnt = 0;
 
-	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist)
-		++cnt;
+	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
+		if (f->state == I40E_FILTER_NEW ||
+		    f->state == I40E_FILTER_ACTIVE)
+			++cnt;
+	}
 
 	return cnt;
 }


