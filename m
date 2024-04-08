Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C327280BF8;
	Mon,  8 Apr 2024 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585162; cv=none; b=TV9cSZ4Ay5RrSPtUoLn0aiIUaTmme4k2ov6akDBExWYH6gCKopn/JVOol6O1M3h8uyR3c+1SBGCNmJRvLTyMZSk8uKwO/dd1wtAyUKibxaHEMrETfbwqZxUg5jQx7yevFCCDR+NhfIlQVMeSWj9/JBfCWL5ltQwSJN8bpkmSww4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585162; c=relaxed/simple;
	bh=BGPP2mNM4raiPsMhB4cbtPLXrSH8JzYhV570iDF4vwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja5+a5FZCIuRIGvi4nTAGIe97gV4QlWz9+0V12vRuetwro3V5DCZU8QRU4+QJSx+iCE5I42hCYb30LmuP4npcpV7Xj43gfdKQwoGmjhMNZ/Aftt20CUUA4Ob6T2/7YghRQLOOR/QlMMcf/uWmr5x3GdPLb09Njli2Kwjw/qwWlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2PtAPC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2PtAPC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A995C433C7;
	Mon,  8 Apr 2024 14:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585162;
	bh=BGPP2mNM4raiPsMhB4cbtPLXrSH8JzYhV570iDF4vwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2PtAPC+sSTWlA3rakrjWTZGOhoM9XxiKN1VcWDq3xr4c19rreorv5QoI3TYMEh/Q
	 tiT2rQ/NHDxlJt93DXwIYA84zEojOn0FVdswulEAFvRrVfHy+6xybRRd3vPBUvcd0a
	 UFJSCW4Dvxs30tvSOCby7oTwGCBT4yT99udw/UwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 654/690] i40e: fix i40e_count_filters() to count only active/new filters
Date: Mon,  8 Apr 2024 14:58:40 +0200
Message-ID: <20240408125423.345991092@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1231,8 +1231,11 @@ int i40e_count_filters(struct i40e_vsi *
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


