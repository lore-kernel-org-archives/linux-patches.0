Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4A747AF6D;
	Sat, 12 Sep 2026 13:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219786; cv=none; b=rPfj/fdE19YGL+FzyZty6VrQmNBf71dFMksYX7b7/3SPrgTpBKOMdFkpg3ZgSgdpRKIJlROLRCTFj5vQzvc/euZQ67wF1DUFRYT3KHgTdUb7eyhGuFfOGpqJAs+Ew+OY+zGKSdE8UBmZXtlciNVbus2MrdNm5Ut6wcpWJfttyco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219786; c=relaxed/simple;
	bh=1WZibmW2NC6vUfVFEIQS55ddd3ESS7P6X1IbfOfbQlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgpkZy2UbPe3u26LNWhQrEjrILEdDmQvuDsHQ/irjoPFCQV+sK60I5/4TYw5cAdVW5LoGhRfYGlHHRmK80NBTQ0vXLXlt2l3N2ixhgT1MTvClDOZIIF8GZGCj2PAOUPodJSChdkNyG8swL85or9VavEJuIoOj2J6WMliOtDSlQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uehaChjg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uehaChjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C4C1F00893;
	Sat, 12 Sep 2026 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219784;
	bh=sMT4+3UOKuyMCMvsWa6ZGdMmZmn2oF7NoRj4yOAK9/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uehaChjgjdQwtI+i/VRWXhRTN+AuqGOmM72l9Axeogyb/tcZtqBZItBLkOqYqnFUO
	 BJN4l/DhaDxLQaXDDaL4XWxVQTpMed1rhjt2iUPGzZg1EbmP6cRmmIKFHWmVoQ/7Hh
	 gUDxqUSMNAc8bq/1yin6EWbwxQUknXG4zzqpCTUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 0044/1424] of: fix out-of-bounds read in of_alias_scan() stem parser
Date: Sat, 12 Sep 2026 08:41:16 +0200
Message-ID: <20260912065608.290295439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 5bb01c657ff9fc807c2c592ca18af34c4fc3bc6f upstream.

The stem parser tests isdigit(*(end - 1)) before checking end > start
and so reads one byte before the property name when the name is empty
or all digits. Check the bound first.

Fixes: 611cad720148 ("dt: add of_alias_scan and of_alias_get_id")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260805-nh-of-alias-overlay-v6-1-74f21d440819@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1784,7 +1784,7 @@ void of_alias_scan(void * (*dt_alloc)(u6
 
 		/* walk the alias backwards to extract the id and work out
 		 * the 'stem' string */
-		while (isdigit(*(end-1)) && end > start)
+		while (end > start && isdigit(*(end - 1)))
 			end--;
 		len = end - start;
 


