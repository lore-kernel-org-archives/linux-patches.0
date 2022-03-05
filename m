Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70FE7E
	for <patches@lists.linux.dev>; Sat,  5 Mar 2022 03:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26752C004E1;
	Sat,  5 Mar 2022 03:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1646451678;
	bh=vYFGMGsjp7fhRtTczjbxOo/YX41ZG9JCEzdMIUdA9Lc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QdVMH2zbYXy+QpcKE3KpU3sstnLSLMt2yPvGNVTEXSmGXMg0ylyfo33NFlhDtPVSZ
	 hGd61+aWho3mBvFsPYYzcodClYbqdodV7d2sIncFZaToa75FGySyPi6vaf30D2aynJ
	 FwrXHdA5k4+DbxRCgF60if/UFh90t+yRvSX8GwJO7o6+UawG9oVg5QL7IHQVjTvBJO
	 wY00G6Fjxl5J4AL6OVZ3u8BZIPAIpswzpRh7dn2FpIAU3vz6LzduJYZ9+FUj4/KvJe
	 STbKebANoHr4PQq7HrGrnpcBHlmwQJiBZQ30LUnR0Qx2djzjMbifpIMhA5fkdH5k29
	 4zehDgfJUFpCQ==
Date: Fri, 4 Mar 2022 19:41:16 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Dimitris Michailidis <d.michailidis@fungible.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
 patches@lists.linux.dev, Dimitris Michailidis <dmichail@fungible.com>,
 "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next?] net: fungible: fix multiple build problems
Message-ID: <20220304194116.613d2fd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOkoqZ=Cy_gXNehJP-o66UO=6X8c93e9NJgnBJgZoEMoYiOzUg@mail.gmail.com>
References: <20220304211524.10706-1-rdunlap@infradead.org>
	<CAOkoqZ=Cy_gXNehJP-o66UO=6X8c93e9NJgnBJgZoEMoYiOzUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 4 Mar 2022 16:39:49 -0800 Dimitris Michailidis wrote:
> > Also, gcc 7.5 does not handle the "C language" vs. #ifdef preprocessor
> > usage of IS_ENABLED() very well -- it is causing compile errors.  
> 
> I believe this is the source of the errors you see but it's not the compiler's
> fault or something specific to 7.5.0. The errors are because when
> IS_ENABLED() is false some of the symbols in the "if" are undefined and the
> compiler checks them regardless.

The compiler will need at least a declaration, right? tls_driver_ctx()
is pretty stupidly hidden under an ifdef, for reasons which I cannot
recall. Maybe we can take it out? 

Same thing could work for fun_tls_tx():

        return skb;
 }
+#else
+struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
+                          unsigned int *tls_len);
 #endif
 
no?
