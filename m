Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50216198E90;
	Thu,  6 Jun 2024 14:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683098; cv=none; b=KiXHJmlZcoSFkGRBGs8hpb9XKTqdcH33lCtAuqy93ihGArcfoG+kdrBGS2X30Lde3lB7+G75hCYet7wLZmudAB9pY2EHOhi7FMJiDOW+G09W1r28yNBAeK1r+CtsgV5DBW4JaqlGIUqXKFnPLdEbzDd4jbWSYknb27+hp4eWBUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683098; c=relaxed/simple;
	bh=GeKsNJQIwq634/NEESdM8spi5OV+aajfsW/aUYGg/Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Piaj5YmlUcd5SwVVIKggP/s3WrC9+pCuKYAo4YbEFCcqzMHAnYTc98W/WF5IEhTyatv1iF3QJcGu/okqi+PDVeL+nm+SXy0zeqX/nV4S+a+KpddWwu4jdka+n+4EegQEqYDRrCh7sE3mqkSnz2g++QBvPZwGChcRp2dU1jk1ieE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STcF5B8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STcF5B8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303E6C32781;
	Thu,  6 Jun 2024 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683098;
	bh=GeKsNJQIwq634/NEESdM8spi5OV+aajfsW/aUYGg/Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STcF5B8UKv2xQu0o0kmoEz9pxlo9laP2v/lVtAfF6NLeUt5YPdj+gwn5pNL4sPvQj
	 DPoTX+7UEmkVZwZZ5mt2IpsIWFH+8M7CtRzml962vS1ir3P3apmfroCzQhEKOKu3i5
	 +3Vvqikm5GZfn8f3B7rd5dnCKg78voD6t/IMGDJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 014/744] net: mana: Fix the extra HZ in mana_hwc_send_request
Date: Thu,  6 Jun 2024 15:54:46 +0200
Message-ID: <20240606131732.909470385@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>

commit 9c91c7fadb1771dcc2815c5271d14566366d05c5 upstream.

Commit 62c1bff593b7 added an extra HZ along with msecs_to_jiffies.
This patch fixes that.

Cc: stable@vger.kernel.org
Fixes: 62c1bff593b7 ("net: mana: Configure hwc timeout from hardware")
Signed-off-by: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1716185104-31658-1-git-send-email-schakrabarti@linux.microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -847,7 +847,7 @@ int mana_hwc_send_request(struct hw_chan
 	}
 
 	if (!wait_for_completion_timeout(&ctx->comp_event,
-					 (msecs_to_jiffies(hwc->hwc_timeout) * HZ))) {
+					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
 		dev_err(hwc->dev, "HWC: Request timed out!\n");
 		err = -ETIMEDOUT;
 		goto out;


