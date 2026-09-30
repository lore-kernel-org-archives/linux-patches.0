Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1175172C1;
	Wed, 30 Sep 2026 16:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785164; cv=none; b=U+cHN5pqPE0mEfA6y3u7hi6xl10t91LEX+jwqhEOAeY0l9WTlTjS1jUQok1CoRuVD4bDcYQOOI5b/D8hlpMj+9eLstKLyiZcGhW7IH/wLJOKQ2ABJvYxQlpUQ9uZshN812Mz4UvJvKkUvQXJPO7v8SSjPxu0yUIOHqeawrGylzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785164; c=relaxed/simple;
	bh=EMvVBP08RlbrmZxlV7ThXSNJGOZ3QMu/jZWR7gqN2l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRIxto5X8voi6pEXJuw4v3RALYIRR/qUntFwORODW4fxlt5pCwHfIJZMfcMTUMSWRIhtFI1bbiGk16+6onXOeolxIO7Qiv1SXCYOSP8pnADiqMj26iS62L3W2ZmUFkyKE0y7WupJdMWU0nuUmmGyM+mYt1whNK4gqosk8U/yq68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rn9v+aOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rn9v+aOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46451F000FF;
	Wed, 30 Sep 2026 16:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785158;
	bh=Zl+PUe7KFdPvJQsz5YBYZHDoMTERSvofD/1wrfV7k9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rn9v+aOLKMlO1hxXrMPVqdM4zqP/wz3T/PKw/oOSq9B4NHFh0Ba3ijXNk0tJQJqjI
	 sNxW8qiCIl5jhFg/Knp59Uqr9jrgIESxtCcP6wzhdZqghmj28/10oy0EQzRmdZO0hI
	 JW2qlaOFiGuYF3Tz3X5Kr8eh0FZfrWDzl9sMQ6FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 411/982] net: dsa: mv88e6xxx: bound the policy rule dump by the callers buffer size
Date: Wed, 30 Sep 2026 17:19:07 +0200
Message-ID: <20260930152425.635341032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b1fffc273112e7284c5b705e186b43b5770cd3d5 ]

mv88e6xxx_get_rxnfc() uses rxnfc->rule_cnt as the write index while
dumping the policy IDR, clobbering the input value before it has been
looked at.  That input is the number of entries the caller had room for.
ETHTOOL_GRXCLSRLALL requires no CAP_NET_ADMIN and the ioctl sizes the
buffer from the rule_cnt userspace passes in, so once an admin has
installed policy rules any user can ask for fewer slots than there are
rules and run off the end of the allocation.  A rule_cnt of 0 leaves the
buffer pointer NULL and the walk dereferences it.

Count into a local so the caller's limit survives the walk, and stop with
-EMSGSIZE once it is reached.

Fixes: da7dc8755304 ("net: dsa: mv88e6xxx: add RXNFC support")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260903032611.3000029-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 17390a004c0e9..9ccf9b7cb6256 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2361,6 +2361,7 @@ static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
 	struct ethtool_rx_flow_spec *fs = &rxnfc->fs;
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_policy *policy;
+	u32 cnt = 0;
 	int err;
 	int id;
 
@@ -2386,11 +2387,18 @@ static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
 		break;
 	case ETHTOOL_GRXCLSRLALL:
 		rxnfc->data = 0;
-		rxnfc->rule_cnt = 0;
-		idr_for_each_entry(&chip->policies, policy, id)
-			if (policy->port == port)
-				rule_locs[rxnfc->rule_cnt++] = id;
 		err = 0;
+		idr_for_each_entry(&chip->policies, policy, id) {
+			if (policy->port != port)
+				continue;
+			if (cnt == rxnfc->rule_cnt) {
+				err = -EMSGSIZE;
+				break;
+			}
+			rule_locs[cnt++] = id;
+		}
+		if (!err)
+			rxnfc->rule_cnt = cnt;
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.53.0



