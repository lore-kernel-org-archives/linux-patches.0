Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90C32C82
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 23:34:53 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so3080121pjb.4
        for <patches@lists.linux.dev>; Wed, 01 Dec 2021 15:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BmII8oD0ACtWYwUxZvVEy7vovgU/Gw+edy4wWYcAnmw=;
        b=RHfduEJ6n32YMSvKhBeO03pKWPjDhvFaHR8aeALHnIyxBMLlyTIFPTkqAxK6boZkkw
         CxnhyMFvKGtoZeLuW0odScpYpkPvwFL4ea6iIkdAE5gDadIudh702XOWTLV9sy22EQ3m
         HAt12qT3rw42CQ2131yuGCrClxLurYtH+6kFmA/4J1wH1pTGTF6jWbMb5XEM937PJJyg
         3xfpvj2buuwv9TIiuz4vZEuLVcEK4QCaF2brbNQjNzU2NJvMYkJBcOJYikzDPuaJBrH8
         LQpx9sjxZQ87ZW/xidwut+pybOBlXrm1Coej5G/GHhQatVMgDYB2jzt6nyIPKAgPg3HG
         C/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BmII8oD0ACtWYwUxZvVEy7vovgU/Gw+edy4wWYcAnmw=;
        b=WduiMOOBHwExixgH1XVYXJkNiB+vhuTeu7efgpabGFuotZ9bPtcmDcSVLEkfolJY89
         q+FOKMxXDs8JbBjlEw+LyRE0/d1EZXbX2TGGvqrw/LOccJwI+0knsqhKRt7B0Rqq3lzi
         tqHE3J7ajJ/ocoJbel0uFMyp7UW2T2ntHgD5JqTsH56HFgTsWgyBBCeYo2mHvU8NQRos
         MD62MzGhoqOoQvau2PNOLtn5bnrzuzuHgisuryViQz4527R3FWnM+oenEH+AqyvWKd/6
         EyPzofFqwJ0Cn97btD08UEQZSS/yOFh58p8weJdpER0ehO/INRAbl377rczN97cWlins
         5uHw==
X-Gm-Message-State: AOAM531f7/xrJK335URrBLDyUMrHoXG50+zgrzL9f7uociGPQjQjO7Lp
	ZXs4ZzOwj8JKEZD0kg6DIhg=
X-Google-Smtp-Source: ABdhPJzchfWaD5sFvck/9D/QjUo2rPBYPl8KRGCBJ6Ayu/URqZ9DK7E0VUaGWHdqnYysgrcqs5SDDg==
X-Received: by 2002:a17:90b:124d:: with SMTP id gx13mr1699614pjb.106.1638401693427;
        Wed, 01 Dec 2021 15:34:53 -0800 (PST)
Received: from google.com ([2620:15c:211:201:e4a9:945b:9a3c:8231])
        by smtp.gmail.com with ESMTPSA id ep15sm1025697pjb.3.2021.12.01.15.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 15:34:53 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date: Wed, 1 Dec 2021 15:34:51 -0800
From: Minchan Kim <minchan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v2 27/33] zsmalloc: Stop using slab fields in struct page
Message-ID: <YagGmz9geekfqwnU@google.com>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-28-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-28-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:04PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> The ->freelist and ->units members of struct page are for the use of slab
> only.  I'm not particularly familiar with zsmalloc, so generate the same
> code by using page->index to store 'page' (page->index and page->freelist
> are at the same offset in struct page).  This should be cleaned up
> properly at some point by somebody who is familiar with zsmalloc.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
