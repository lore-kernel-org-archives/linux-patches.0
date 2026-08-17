Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E8C3EFFB9;
	Mon, 17 Aug 2026 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974635; cv=none; b=Rk0gxScJ+G2IFJXErDxIJEaZqC8I2qs5z81SnJY4ZP3Y61kyAJnDvp0SA+OI1dL5bN2gZ/I/D7G3tMg7QF3o4g3+OvSGgbaHLLnUbyCOq3Z5q0wCaL/8d8vQA1lJl5CsthwYUkWaONLbmTIE+iOECext+1shW0bkh6cidp+FCdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974635; c=relaxed/simple;
	bh=HhbqKGwQF+xxsYOi1vHFeCSPLICp3RbsfEe7k5f/s8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVieDFacZah53zA/Hr9Ppp+nxCBPK2hPY3Fs1+NtJhk/3+pVRYrp6q4jjDvY5zWvxvLeO9//VnQJwHEyaUFKR0wShI3KAeWaOscsuDFaJ0ugRgYxDPOwKZPKIHHpKqhHz86fWjIEmlLrlpI1q1EhcN0+FyW7/mkifr56HCljMcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocYax8fp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocYax8fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652EC1F000E9;
	Mon, 17 Aug 2026 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974628;
	bh=52ju4CbS9fCTlcg7DAHN8vl58w3hs3UjATdv833MKkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocYax8fpd2TzuQhMtIONexfOEVBwAQRWFj+xhtY9jUfLDY9+P+H4yW6lRXgVOkEZI
	 8kVEOzk0ZzAks4SGxnf6BPpsrkHBl68+7/p7sJHGg0w0TSye22A6OLUX/D74c1nI4P
	 8SgJUBPcwzfVEMWod4LvlJv3eFVkRexnLSjhdoPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.1 271/271] thunderbolt: Fix bandwidth group reservation indexing
Date: Mon, 17 Aug 2026 15:33:16 +0200
Message-ID: <20260817132547.850903959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit d2ee4d47aacbd2ba456092eeec670dba35fde291 upstream.

Valid bandwidth group IDs range from 1 through MAX_GROUPS, while Group
ID 0 is reserved. tb_consumed_dp_bandwidth() uses the Group ID directly
to index its local group_reserved[] array.

The array currently has MAX_GROUPS entries, so its valid indices are 0
through MAX_GROUPS - 1. Group ID MAX_GROUPS therefore accesses one
element past the end, and the final group's reserved bandwidth is not
included when the array is summed.

Give group_reserved[] MAX_GROUPS + 1 entries so direct Group ID
indexing covers the reserved ID 0 and valid IDs 1 through MAX_GROUPS.

Fixes: 52a4490e89d7 ("thunderbolt: Reserve released DisplayPort bandwidth for a group for 10 seconds")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -609,7 +609,7 @@ static int tb_consumed_dp_bandwidth(stru
 				    int *consumed_up,
 				    int *consumed_down)
 {
-	int group_reserved[MAX_GROUPS] = {};
+	int group_reserved[MAX_GROUPS + 1] = {};
 	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_tunnel *tunnel;
 	bool downstream;


