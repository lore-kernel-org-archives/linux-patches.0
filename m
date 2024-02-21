Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C80C763F6;
	Wed, 21 Feb 2024 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521663; cv=none; b=cun+KaxVwnRgr8t6rrPxLE/MPVXbzwpWmdNHmR07VY/vCLgDt9wsiWEJh2JY1fWntNFR85D17sxWOvpEPA77ydfvtMNwMCCv5SNG8HN3KCMOhiw4yZtJkRqrvL4TnHJlf3H7epXhVBDb1HWSSSmMsi14pu47wxh4u96v3QEw41E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521663; c=relaxed/simple;
	bh=yB2H6YZnA5kl+JIL283Ui2F7W/CGbJpc4u95v+fu49Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFoBUit6ujH05QLSAka4xrfjV7/I4B6dBPL+LtvUY/1UXk8WIWKW18E97MozTU/2rJKtleOydanbvxI7OqrEPUS0HdjBWcgMsmz4A0d4ii9sgsvWt4pbi9vgg/V4sV/ZtA7zAsg/m+sqq9YXYl6GapDUFzyyIR+BL1Oz27be4Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ehmx0pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ehmx0pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93AAC433C7;
	Wed, 21 Feb 2024 13:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521663;
	bh=yB2H6YZnA5kl+JIL283Ui2F7W/CGbJpc4u95v+fu49Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ehmx0peYoJxqKs2CF5EB+F9QU7jnQ9/bmUe3agyuHF3mhuYNi2GL0OSbILtiJYdO
	 NLP8Z++KoEVtDO2HHekxkdhp0EtBqZNd0Icjtve1aJhSZOThF6jITsoeAziEInKHbO
	 Ae2+uXpTp1I8vXhcx3RSZyNgUqS469lEREcfoSQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 145/202] bonding: remove print in bond_verify_device_path
Date: Wed, 21 Feb 2024 14:07:26 +0100
Message-ID: <20240221125936.393828140@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit 486058f42a4728053ae69ebbf78e9731d8ce6f8b upstream.

As suggested by Paolo in link[1], if the memory allocation fails, the mm
layer will emit a lot warning comprising the backtrace, so remove the
print.

[1] https://lore.kernel.org/all/20231118081653.1481260-1-shaozhengchao@huawei.com/

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2460,11 +2460,8 @@ struct bond_vlan_tag *bond_verify_device
 
 	if (start_dev == end_dev) {
 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
-		if (!tags) {
-			net_err_ratelimited("%s: %s: Failed to allocate tags\n",
-					    __func__, start_dev->name);
+		if (!tags)
 			return ERR_PTR(-ENOMEM);
-		}
 		tags[level].vlan_proto = VLAN_N_VID;
 		return tags;
 	}


