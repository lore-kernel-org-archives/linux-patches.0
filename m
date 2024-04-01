Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F00A1CA8F;
	Mon,  1 Apr 2024 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987422; cv=none; b=ZDvJk6fOnIsS0fqP5IIPJsLkyqIfMAixDuIDCJTzNEVKzOkJX815rpFJ2okyUmIbTWnLevZegMxXz6YW2lUop6hWynb5V6cWYKgfQlo+x5xee+m3+DUoZd2owxy76q96d+OQK94lBERdumh25luuLJS/f3neXsy0q8FUc8hkMEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987422; c=relaxed/simple;
	bh=CRplDSUImZThNYT1a+48Q434H0LQy3cMs/OX028udHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D16oReOnwH474QD5pZoWCxfA4F3C4B8Rnm5tTxsR2HDgIRHOH7vVPISZz0vPDlnWi8GCophq+lqF9BmldNxDWN5l8+QuoHh/EeRWyms5w7o14JhmzIw/ZiQhG2nzyol8OIbJ9Wfv6ZB0P4u6ZpzhZT7dMLSx4Ke95HSwxwfQupg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb9KnOOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb9KnOOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2C3C433F1;
	Mon,  1 Apr 2024 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987422;
	bh=CRplDSUImZThNYT1a+48Q434H0LQy3cMs/OX028udHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sb9KnOOgULBcc3F5hW+rvd9+Qc4W+M/g4WJOIhpEuyY3vY+iB7JyrwT9IlK3bdICX
	 NuJDhgnQJ3UGR3aG2KSkRehHy2ENs7gBDK83a1wnTlbxO4s6UQKb7eh+lkNbrZL4ew
	 3l7wpoY2L0W5SaZx12zePziMn6LArERVqDZ7gj0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.8 282/399] crypto: iaa - Fix nr_cpus < nr_iaa case
Date: Mon,  1 Apr 2024 17:44:08 +0200
Message-ID: <20240401152557.600663281@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Zanussi <tom.zanussi@linux.intel.com>

commit 5a7e89d3315d1be86aff8a8bf849023cda6547f7 upstream.

If nr_cpus < nr_iaa, the calculated cpus_per_iaa will be 0, which
causes a divide-by-0 in rebalance_wq_table().

Make sure cpus_per_iaa is 1 in that case, and also in the nr_iaa == 0
case, even though cpus_per_iaa is never used if nr_iaa == 0, for
paranoia.

Cc: <stable@vger.kernel.org> # v6.8+
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -908,6 +908,8 @@ static int save_iaa_wq(struct idxd_wq *w
 		return -EINVAL;
 
 	cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
+	if (!cpus_per_iaa)
+		cpus_per_iaa = 1;
 out:
 	return 0;
 }
@@ -923,10 +925,12 @@ static void remove_iaa_wq(struct idxd_wq
 		}
 	}
 
-	if (nr_iaa)
+	if (nr_iaa) {
 		cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-	else
-		cpus_per_iaa = 0;
+		if (!cpus_per_iaa)
+			cpus_per_iaa = 1;
+	} else
+		cpus_per_iaa = 1;
 }
 
 static int wq_table_add_wqs(int iaa, int cpu)


