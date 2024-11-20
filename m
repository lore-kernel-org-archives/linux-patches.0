Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5B81BF7F9;
	Wed, 20 Nov 2024 13:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107707; cv=none; b=JSrs2Yjqx6J8FKzNE3mW5z5JNRqViMAMri7FULf+YbQe9uT5rpmc6jlpKtbe+O6VW20flJC/sV4I+X8ArruIGvf7Dl4us7ibj/6TOTVK2oPBBMrO4NRTDkidhndQh+7hN9BbYAkFOY85YDSbP/Fdjof4yxRXkmFwdOwoKTVvwWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107707; c=relaxed/simple;
	bh=x3CAbpj2PvJXe+lqBr40ARJguxzSBalLtmDzp+F3+/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L92vRIC0GbNYaYZnb7IKtA9jN8eQcNemvqmv5zHCQu3RTKazwQXqlX0yOh2WymJPelQbIVgX8lOw7otbiMA67FrWSNNRfAXw/DUE9abOV/d2kn7+sVlhakbTNo4r8wPlKUZ53aswfsmbmiGR0QSEwxLJA4BwybZyVN9RJqXADac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPsMi+GQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPsMi+GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0F9C4CED1;
	Wed, 20 Nov 2024 13:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107707;
	bh=x3CAbpj2PvJXe+lqBr40ARJguxzSBalLtmDzp+F3+/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPsMi+GQ+WVQvFVnntHrcCbfPYMZ7iOEPZ994rnA3/R74lqHX0Ws/2B2+O8lTAhiw
	 buAoKgPiyxlD4MiOEtcT6lgxBvmLUbBL9aNWZ4sE+aRAdGroJvyxF39gkXJpVaD7bi
	 ++GtExO7AIRnQ/Ufwv9QPvabRMZRPmn1HtNFxFc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 6.1 72/73] char: xillybus: Fix trivial bug with mutex
Date: Wed, 20 Nov 2024 13:58:58 +0100
Message-ID: <20241120125811.329307492@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Eli Billauer <eli.billauer@gmail.com>

commit c002f04c0bc79ec00d4beb75fb631d5bf37419bd upstream.

@unit_mutex protects @unit from being freed, so obviously it should be
released after @unit is used, and not before.

This is a follow-up to commit 282a4b71816b ("char: xillybus: Prevent
use-after-free due to race condition") which ensures, among others, the
protection of @private_data after @unit_mutex has been released.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20221117071825.3942-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillybus_class.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/char/xillybus/xillybus_class.c
+++ b/drivers/char/xillybus/xillybus_class.c
@@ -227,14 +227,15 @@ int xillybus_find_inode(struct inode *in
 			break;
 		}
 
-	mutex_unlock(&unit_mutex);
-
-	if (!unit)
+	if (!unit) {
+		mutex_unlock(&unit_mutex);
 		return -ENODEV;
+	}
 
 	*private_data = unit->private_data;
 	*index = minor - unit->lowest_minor;
 
+	mutex_unlock(&unit_mutex);
 	return 0;
 }
 EXPORT_SYMBOL(xillybus_find_inode);


