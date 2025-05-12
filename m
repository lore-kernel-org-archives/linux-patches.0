Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18DE298264;
	Mon, 12 May 2025 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073267; cv=none; b=JJi72ubck+8YYcMCejMSRqPj92Xf0hmdOPhKWYd7RGT28AY3YRUpeQuy0RwKlmA3rsSK8M2dmn1Hzpr5ribXuvNvT3EAOYsSMRN0iXZkSnRkYxw0sHlKCg7KORwiO1W3SlN+S+tZFiycS1eLEbD+Yjmp3hV3fhETILjLLlGlYnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073267; c=relaxed/simple;
	bh=1AW0l48p4B58EZjtT6O/rb8xBRZLBUT2GmI0Hguvtfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRUnEO3grPzLcBh9KyXe2TiE2QkXXDk0fY4ZuidMkxN9Cn0DoI0TQKju+FQeNOd4RfDi3jhDmgeAQWtJu9SKh9Pbi96KijH64RcuYyRHvH1JEefKXfGGVHQxIS8nyjIb30ZdeB09ukIUb/JbIRenueJ86tggMe3JYVZjst4KUFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psVUQK8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psVUQK8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D64C4CEE7;
	Mon, 12 May 2025 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073266;
	bh=1AW0l48p4B58EZjtT6O/rb8xBRZLBUT2GmI0Hguvtfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psVUQK8/SMOKEbQ48/JL6+yQ5ITaOSV+KNVHh4ttAIGNlf5kOlUJEkshYsG/GBIoX
	 YMKQTKY2CVw4TdGQ7D0mwXZaFTsTSRsA/DJrGufpcg5doS8ICM9w36mi5uwH4TH6E9
	 YBNa6qzRCqcyKTT1wH1l3UYZDUAjzazCmg6EF0PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 009/113] openvswitch: Fix unsafe attribute parsing in output_userspace()
Date: Mon, 12 May 2025 19:44:58 +0200
Message-ID: <20250512172028.078705964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eelco Chaudron <echaudro@redhat.com>

commit 6beb6835c1fbb3f676aebb51a5fee6b77fed9308 upstream.

This patch replaces the manual Netlink attribute iteration in
output_userspace() with nla_for_each_nested(), which ensures that only
well-formed attributes are processed.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Acked-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/0bd65949df61591d9171c0dc13e42cea8941da10.1746541734.git.echaudro@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -959,8 +959,7 @@ static int output_userspace(struct datap
 	upcall.cmd = OVS_PACKET_CMD_ACTION;
 	upcall.mru = OVS_CB(skb)->mru;
 
-	for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
-	     a = nla_next(a, &rem)) {
+	nla_for_each_nested(a, attr, rem) {
 		switch (nla_type(a)) {
 		case OVS_USERSPACE_ATTR_USERDATA:
 			upcall.userdata = a;


