Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACD17E0E4;
	Mon,  8 Apr 2024 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582854; cv=none; b=UxquRPyN9g4kedT3wXanv1ax3QDdTcf8DZqGA7NM2q3O3CBPP1mPGZClSJtd9BSw46ps9BUIMpmq/vL1xe8p4x+E29tCo6XpZew1xMzsUYZtDKRcmKJdY621SObFvhMUYU+z4Zz4mezV32DSC05/f54UG0gGqE4vgXMpCJsZmIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582854; c=relaxed/simple;
	bh=xPmTm84NxUAUAWZHHiD+NSkb5F96RVbrHcxgAm8fzHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czwLL4JHgI06iMTKF/JMN371mbOpXhgxfLKqUtNmcBk/RW4lbr2+jahCv1v9vsUb6s8CICOpKvHOIFym2d7aaZHncDEAuPnMuisGZKgtuXJUY1zbxJmN+Z/dteA1qvDr261ayVTtL9ThpJHCbPk0R3+++6mFxn/6J8+X741J1sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFcpFiRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFcpFiRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0980BC433C7;
	Mon,  8 Apr 2024 13:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582854;
	bh=xPmTm84NxUAUAWZHHiD+NSkb5F96RVbrHcxgAm8fzHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFcpFiRLUQn9gM8h/H8fCcfcj3UPGi2wiiv+0GND7sYzup1bLktGEszIb6TBjxXgt
	 5AhU+scn5YYqwhWcvuTssa9DkjeJthfr4uI1ENVOygbH/4Fel+7Ubce8ByZatbr488
	 Ze86XB+DKzEHgB0z3L36YuSyWkwoVUKcAz/2LUSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.6 129/252] i40e: fix i40e_count_filters() to count only active/new filters
Date: Mon,  8 Apr 2024 14:57:08 +0200
Message-ID: <20240408125310.625524080@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


